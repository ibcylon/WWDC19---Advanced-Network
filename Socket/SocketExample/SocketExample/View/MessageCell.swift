//
//  MessageCell.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import SwiftUI

struct MessageCell: View {
  @State var message: Message
  var body: some View {
    HStack {
      if message.isMe {
        Spacer()
      }
      VStack {
        Text(message.userID.uuidString.prefix(5))
        Text(message.content)
          .padding(15.0)
          .foregroundStyle(Color.white)
          .background(message.isMe ? Color.blue : Color.gray)
          .clipShape(Capsule())
          .lineLimit(2)
      }

      if !message.isMe {
        Spacer()
      }
    }
  }
}

#Preview {
  Group {
    MessageCell(message: Message(userID: UUID(), content: "asdf", isMe: true))
    MessageCell(message: Message(userID: UUID(), content: "asdfadf", isMe: false))
  }
}
