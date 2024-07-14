//
//  View+applyIf.swift
//  Common
//
//  Created by 쩡화니 on 7/12/24.
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
}
