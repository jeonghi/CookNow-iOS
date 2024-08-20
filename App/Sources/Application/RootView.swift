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
  @StateObject private var coordinator: UICoordinator = .shared
}

extension RootView: View {
  var body: some View {
    ZStack {
      if coordinator.isLoggedIn {
        MainTabView()
      } else {
        OnboardingView()
      }
    }
  }
}

extension RootView {
  
}

#Preview {
  RootView()
    .environment(\.locale, Locale(identifier: "en-US"))
}
