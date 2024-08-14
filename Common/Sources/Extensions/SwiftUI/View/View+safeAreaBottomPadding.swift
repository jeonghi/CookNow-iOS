//
//  View+safeAreaBottomPadding.swift
//  Common
//
//  Created by 쩡화니 on 8/12/24.
//

import SwiftUI

struct SafeAreaBottomPaddingModifier: ViewModifier {
  let defaultPadding: CGFloat
  let safeAreaPadding: CGFloat
  let edges: CGFloat
  
  func body(content: Content) -> some View {
    content
      .padding(.bottom, edges == 0 ? defaultPadding : safeAreaPadding)
  }
}

public extension View {
  func safeAreaBottomPadding(
    defaultPadding: CGFloat = 0,
    safeAreaPadding: CGFloat = 0
  ) -> some View {
    let edges = UIApplication.bottomSafeAreaInsets
    return self.modifier(SafeAreaBottomPaddingModifier(defaultPadding: defaultPadding, safeAreaPadding: safeAreaPadding, edges: edges))
  }
}


