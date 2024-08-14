//
//  LazyNavigationView.swift
//  Common
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI

public struct LazyNavigationView<T: View>: View {
  
  let build: () -> T
  
  public init(_ build: @autoclosure @escaping () -> T) {
    self.build = build
  }
  
  public var body: some View {
    build()
  }
}
