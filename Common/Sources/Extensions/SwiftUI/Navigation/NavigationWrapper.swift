//
//  NavigationWrapper.swift
//  Common
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI

public struct NavigationWrapper<Content: View>: View {
  
  let content: Content
  
  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  public var body: some View {
    if #available(iOS 16.0, *) {
      NavigationStack {
        content
      }
    } else {
      NavigationView {
        content
      }
    }
  }
}
