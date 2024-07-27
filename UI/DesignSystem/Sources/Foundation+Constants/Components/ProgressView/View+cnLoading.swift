//
//  View+cnLoading.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/27/24.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
  @Binding var isLoading: Bool
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .blur(radius: isLoading ? 3 : 0)
      
      if isLoading {
        Color.black.opacity(0.5)
          .ignoresSafeArea()
        
        CNProgressView()
      }
    }
  }
}

public extension View {
  func cnLoading(_ isLoading: Binding<Bool>) -> some View {
    self.modifier(LoadingModifier(isLoading: isLoading))
  }
}
