//
//  SocketStore.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation

final class SocketStore: ObservableObject {
  @Published var messages: [Message] = []
  let userID = UUID()
  var userName: String {
    "name: " + userID.uuidString.prefix(5)
  }

  var socket: WebSocketConnection?

  init(socket: WebSocketConnection) {
    self.socket = socket
    self.socket?.delegate = self
  }

  func send(text: String) {
    let dto = MessageDTO(content: text, userID: userID)
    send(message: dto)
  }

  func send(message: MessageDTO) {
    let domain = Message(userID: self.userID, content: message.content, isMe: true)
    messages.append(domain)
    socket?.send(message)
  }
}

extension SocketStore: WebSocketConnectionDelegate {
  func onConnected(connection: WebSocketConnection) {

  }
  
  func onDisconnected(connection: WebSocketConnection, error: Error?) {

  }
  
  func onError(connection: WebSocketConnection, error: Error?) {
    if let error = error {
      print("error: \(error.localizedDescription )")
    }
  }
  
  func onMesssage(connection: WebSocketConnection, text: String) {
    print(text)
  }
  
  func onMessage(connection: WebSocketConnection, data: Data) {
    if 
      let message = try? JSONDecoder().decode(MessageDTO.self, from: data),
      message.userID != self.userID
    {
      DispatchQueue.main.async {
        let domain = Message(userID: message.userID, content: message.content, isMe: false)
        self.messages.append(domain)
      }
    }
  }
}
