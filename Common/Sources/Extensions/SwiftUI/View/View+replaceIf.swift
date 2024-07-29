//
//  View+replaceIf.swift
//  Common
//
//  Created by 쩡화니 on 7/29/24.
//

import SwiftUI

extension View {
  @ViewBuilder
  public func replaceIf<T: View>(_ condition: Bool, @ViewBuilder replacement: () -> T) -> some View {
    if condition {
      replacement()
    } else {
      self
    }
  }
}
