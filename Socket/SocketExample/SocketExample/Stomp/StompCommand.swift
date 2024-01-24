//
//  StompCommand.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation

enum ClientCommand: String {
  case send = "SEND"
  case subscribe = "SUBSCRIBE"
  case unsubscribe = "UNSUBSCRIBE"
  case begin = "BEGIN"
  case commit = "COMMIT"
  case abort = "ABORT"
  case ack = "ACK"
  case nack = "NACK"
  case connect = "CONNECT"
  case disconnect = "DISCONNECT"
  case stomp = "STOMP"
}

enum ServerCommand: String {
  case connected = "CONNECTED"
  case message = "MESSAGE"
  case receipt = "RECEIPT"
  case error = "ERROR"
}

struct StompFrame {
  var command: String?
  var header: [String: Any] = [:]
  var body: String

  mutating func makeFrame() -> String {
    var frame: String = ""
    frame += command ?? "" + "\n"
    for (key, value) in header {
      let line = "\(key) : \(value)"
      frame += line + "\n"
    }
    frame += "\n"
    frame += body
//    frame += NSNull()

    return frame
  }
}
