//
//  ContentView.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import SwiftUI

struct ContentView: View {
  @State private var message: String = ""
  @ObservedObject private var store = SocketStore(socket: NativeSocket(url: URL(string: "ws://localhost:3000")!))

  var body: some View {
    VStack {
      Text(store.userName)
        .padding(.trailing)
      List {
        ForEach(store.messages) { message in
          MessageCell(message: message)
        }
      }
      HStack {
        TextField("message", text: $message)
          .keyboardType(.asciiCapableNumberPad)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled(true)
        Button("Send") {
          send()
          endEditing()
        }.disabled(message.isEmpty)
      }
      .padding()
      .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    .onTapGesture {
      endEditing()
    }
  }

  func send() {
    store.send(text: message)
    message = ""
  }
}

extension View {
  func endEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

#Preview {
  ContentView()
}
