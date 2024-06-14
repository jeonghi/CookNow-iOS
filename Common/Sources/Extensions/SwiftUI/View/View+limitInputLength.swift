//
//  View+limitInputLength.swift
//  Common
//
//  Created by 쩡화니 on 6/14/24.
//

import SwiftUI

public extension View {
  func limitInputLength(value: Binding<String>, length: Int) -> some View {
    self.modifier(TextFieldLimitModifer(value: value, length: length))
  }
}

private struct TextFieldLimitModifer: ViewModifier {
  @Binding var value: String
  var length: Int
  
  func body(content: Content) -> some View {
    content
      .onReceive(value.publisher.collect()) {
        value = String($0.prefix(length))
      }
  }
}
