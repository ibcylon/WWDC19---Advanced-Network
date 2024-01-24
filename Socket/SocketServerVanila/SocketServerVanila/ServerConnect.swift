//
//  ServerConnect.swift
//  SocketServerVanila
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation
import Network

protocol ServerConnectionProtocol {
  var didStopCallback: ((Error?) -> Void)? { get set }
  var didReceive: ((Data) -> Void)? { get set }

  func start()
  func handleMessage(data: Data, context: NWConnection.ContentContext)
  func stop()
  func send(data: Data)
}

class ServerConnection: ServerConnectionProtocol {
  private static var nextID: Int = 0

  let connection: NWConnection
  let id: Int

  init(nwConnection: NWConnection) {
    connection = nwConnection
    id = ServerConnection.nextID
    ServerConnection.nextID += 1
  }

  deinit {
    print("deinit")
  }

  var didStopCallback: ((Error?) -> Void)? = nil
  var didReceive: ((Data) -> Void)? = nil

  func start() {
    print("connection \(id) will start")
    connection.stateUpdateHandler = self.stateDidChange(to:)
    setupReceive()
    connection.start(queue: .main)
  }

  private func stateDidChange(to state: NWConnection.State) {
    switch state {
    case .setup:
      print("connection setup")
    case .waiting(let nWError):
      print("connection wating. reason: \(nWError.localizedDescription)")
    case .preparing:
      print("connection preparing")
    case .ready:
      print("connection \(id) ready")
    case .failed(let nWError):
      print("connection failed. \(nWError.localizedDescription)")
      connectionDidFail(error: nWError)
    case .cancelled:
      print("connection canceled")
    @unknown default:
      print("unknown")
    }
  }

  private func setupReceive() {
    connection.receiveMessage { [weak self] content, context, isComplete, error in
      if let data = content, let context = context, !data.isEmpty {
        self?.handleMessage(data: data, context: context)
      }
      if let error = error {
        self?.connectionDidFail(error: error)
      } else {
        self?.setupReceive()
      }
    }
  }

  func handleMessage(data: Data, context: NWConnection.ContentContext) {
    didReceive?(data)
  }

  func send(data: Data) {
    let metaData = NWProtocolWebSocket.Metadata(opcode: .binary)
    let context = NWConnection.ContentContext(identifier: "context", metadata: [metaData])
    connection.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed { [weak self] error in
      guard let self = self else { return }
      if let error = error {
        self.connectionDidFail(error: error)
        return
      }
      print("connection \(self.id) did send, data: \(data as NSData)")
    })
  }

  func stop() {
    print("connection \(id) will stop")
  }

  private func connectionDidFail(error: Error) {
    print("connection \(id) did fail, error: \(error.localizedDescription)")
    stop(error: error)
  }

  private func connectionDidEnd() {
    print("connection \(id) did end")
    stop(error: nil)
  }

  private func stop(error: Error?) {
    connection.stateUpdateHandler = nil
    connection.cancel()

    if let didStopCallback = didStopCallback {
      self.didStopCallback = nil
      didStopCallback(error)
    }
    didReceive = nil
  }

}
