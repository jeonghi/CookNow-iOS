//
//  RootView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import Onboading

struct RootView {
  @State var isLoggedIn: Bool = true
}

extension RootView: View {
  var body: some View {
    if !isLoggedIn {
      OnboardingView()
    } else {
      MainTabView(selectedTab: .IngredientsBox)
    }
  }
}

extension RootView {
  
}

#Preview {
  RootView()
    .environment(\.locale, Locale(identifier: "en-US"))
}
