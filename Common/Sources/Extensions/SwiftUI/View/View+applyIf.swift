//
//  View+applyIf.swift
//  Common
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI

public extension View {
  @ViewBuilder
  func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  @ViewBuilder
  func applyIfNotNil<T, V: View>(_ value: T?, apply: (Self, T) -> V) -> some View {
    if let unwrappedValue = value {
      apply(self, unwrappedValue)
    } else {
      self
    }
  }
}
