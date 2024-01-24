//
//  SocketProtocol.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation

protocol WebSocketConnection {
  func connect()
  func disconnect()
  func readMessage()
  func sendPing(handler: @escaping (TimeInterval?) -> Void)
  func send(_ message: MessageDTO)

  var delegate: WebSocketConnectionDelegate? { get set }
}

protocol WebSocketConnectionDelegate: AnyObject {
  func onConnected(connection: WebSocketConnection)
  func onDisconnected(connection: WebSocketConnection, error: Error?)
  func onError(connection: WebSocketConnection, error: Error?)
  func onMesssage(connection: WebSocketConnection, text: String)
  func onMessage(connection: WebSocketConnection, data: Data)
}
