//
//  MySocektServer.swift
//  SocketServerVanila
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation
import Network

protocol WSNetworkProtocol {
  func connect() throws
  func disconnet()
  func startDidChanges(to newState: NWListener.State)
  func didAccept(nwConnection: NWConnection)
}

class SwiftVanilaSocketServer: WSNetworkProtocol {
  let port: NWEndpoint.Port
  let listener: NWListener
  let parameters: NWParameters

  private var connectionByID: [Int: ServerConnection] = [:]

  init(port: UInt16) {
    self.port = NWEndpoint.Port(rawValue: port)!
    parameters = NWParameters(tls: nil)
    parameters.allowLocalEndpointReuse = true
    parameters.includePeerToPeer = true

    let wsoptions = NWProtocolWebSocket.Options()
    wsoptions.autoReplyPing = true
    parameters.defaultProtocolStack.applicationProtocols.insert(wsoptions, at: 0)
    listener = try! NWListener(using: parameters, on: self.port)
  }

  func connect() throws {
    print("Server Starting..")
    listener.stateUpdateHandler = self.startDidChanges(to:)
    listener.newConnectionHandler = self.didAccept(nwConnection:)
    listener.start(queue: .main)
  }

  func disconnet() {
    self.listener.stateUpdateHandler = nil
    self.listener.newConnectionHandler = nil
    self.listener.cancel()

    for connection in self.connectionByID.values {
      connection.didStopCallback = nil
      connection.stop()
    }
  }

  func startDidChanges(to newState: NWListener.State) {
    switch newState {
    case .setup:
      print("Server setup!")
    case .waiting(let nWError):
      print("server waiting... reason: \(nWError.localizedDescription)")
    case .ready:
      print("Server ready")
    case .failed(let nWError):
      print("Server failure, error: \(nWError.localizedDescription)")
      exit(EXIT_FAILURE)
    case .cancelled:
      print("Server cancel")
    @unknown default:
      print("unkwnon default")
    }
  }

  func didAccept(nwConnection: NWConnection) {
    let connection = ServerConnection(nwConnection: nwConnection)
    connectionByID[connection.id] = connection

    connection.start()

    connection.didStopCallback = { [weak self] error in
      if let error = error {
        print(error.localizedDescription)
      }
      self?.connectionDidStop(connection)
    }

    connection.didReceive = { [weak self] data in
      self?.connectionByID.values.forEach { connection in
        print("sent \(String(data: data, encoding: .utf8) ?? "Nothing") to open connection")
        connection.send(data: data)
      }
    }

    connection.send(data: "Welcome you are connection: \(connection.id)".data(using: .utf8)!)
    print("server did open connection\(connection.id)")
  }

  private func connectionDidStop(_ connection: ServerConnection) {
    self.connectionByID.removeValue(forKey: connection.id)
    print("server did close connection \(connection.id)")
  }
}
