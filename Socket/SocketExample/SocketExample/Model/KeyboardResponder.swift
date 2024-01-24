//
//  KeyboardResponder.swift
//  SocketExample
//
//  Created by Kanghos on 2024/01/21.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {

  @Published private(set) var currentHeight: CGFloat = 0
  private var cancellable: Set<AnyCancellable> = []

  var keyboardWillShowNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
  var keyboardWillHideNotification = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

  init() {
    keyboardWillShowNotification
      .compactMap {
        $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
      }
      .map { $0.cgRectValue.height }
      .assign(to: \.currentHeight, on: self)
      .store(in: &cancellable)

    keyboardWillHideNotification
      .map { _ in CGFloat(0) }
      .assign(to: \.currentHeight, on: self)
      .store(in: &cancellable)
  }
}

struct KeyboardAdaptive: ViewModifier {
  @ObservedObject private var keyboard = KeyboardResponder()

  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboard.currentHeight)
  }
}
