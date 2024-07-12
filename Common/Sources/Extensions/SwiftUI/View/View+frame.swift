//
//  View+frame.swift
//  Common
//
//  Created by 쩡화니 on 7/12/24.
//

import SwiftUI

public extension View {
  func frameAllInfinity() -> some View {
    self.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
