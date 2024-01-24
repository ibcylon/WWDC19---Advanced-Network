//
//  NativeSocket.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation
import Network

final class NativeSocket: NSObject, WebSocketConnection {
  weak var delegate: WebSocketConnectionDelegate?
  var webSocketTask: URLSessionWebSocketTask?

  init(url: URL) {
    super.init()

    webSocketTask = URLSession.shared.webSocketTask(with: url)
    connect()
  }

  func connect() {
    webSocketTask?.resume()

    readMessage()
  }
  
  func disconnect() {
    webSocketTask?.cancel(with: .normalClosure, reason: nil)
    webSocketTask = nil
  }
  
  func readMessage() {
    guard let task = self.webSocketTask else { return }
    task.receive { result in
      switch result {
      case .success(.data(let data)):
        self.delegate?.onMessage(connection: self, data: data)
        self.readMessage()
      default:
        self.disconnect()
      }
    }
  }
  
  func sendPing(handler: @escaping (TimeInterval?) -> Void) {
    webSocketTask?.sendPing(pongReceiveHandler: { error in
      if let error = error {
        print("send ing failed" + error.localizedDescription)
      }
      handler(25)
    })
  }
  
  func send(_ message: MessageDTO) {
    if let data = try? JSONEncoder().encode(message) {
      webSocketTask?.send(.data(data), completionHandler: { error in
        if let error = error {
          self.delegate?.onError(connection: self, error: error)
        }
      })
    }
  }
}
