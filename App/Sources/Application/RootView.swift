//
//  RootView.swift
//  App
//
//  Created by 쩡화니 on 8/14/24.
//

import SwiftUI
import Onboading

struct RootView {
  @StateObject private var coordinator: UICoordinator = .init()
}

extension RootView: View {
  var body: some View {
    if coordinator.isLoggedIn {
      MainTabView(coordinator: coordinator)
    } else {
      OnboardingView()
    }
  }
}

extension RootView {
  
}

#Preview {
  RootView()
    .environment(\.locale, Locale(identifier: "en-US"))
}
