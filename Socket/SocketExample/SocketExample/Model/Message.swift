//
//  Model.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import Foundation

struct MessageDTO: Codable {
  let content: String
  let userID: UUID

  init(content: String, userID: UUID) {
    self.content = content
    self.userID = userID
  }
}

struct Message: Identifiable {
  var id = UUID()
  let userID: UUID
  let content: String
  let isMe: Bool
}
