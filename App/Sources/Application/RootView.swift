//
//  RootView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import Onboading
import Auth


struct RootView {
  @ObservedObject private var tokenManager = TokenManager.shared
  var isLoggedIn: Bool {
    if let token = tokenManager.token,
       !token.isAccessTokenExpired {
      return true
    }
    return false
  }
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
