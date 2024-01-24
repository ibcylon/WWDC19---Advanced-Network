//
//  MySocket.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation


final class MySocketClient: WebSocketConnection {
  var delegate: WebSocketConnectionDelegate?

  static let shared = MySocketClient()

  let testServerURL = URL(string: "ws://localhost:3000")!
  var webSocektTask: URLSessionWebSocketTask?

  var applyMessage: ((String) -> Void) = { str in
    print(str)
  }

  func connect() {
    let task = URLSession.shared.webSocketTask(with: testServerURL)
    self.webSocektTask = task

    task.resume()
    readMessage()
  }

  func disconnect() {
    webSocektTask?.cancel()
    webSocektTask = nil
  }

  func readMessage() {
    guard let task = self.webSocektTask else { return }
    task.receive { result in
      switch result {
      case .success(.data(let data)):
        if let value = try? JSONDecoder().decode(String.self, from: data) {
          self.applyMessage(value)
        }
        self.readMessage()
      default:
        self.disconnect()
      }
    }
  }

  func send(_ message: MessageDTO) {
    guard let task = self.webSocektTask else { return }
 
  }

  func sendPing(handler: @escaping (TimeInterval?) -> Void) {
    
  }
}
