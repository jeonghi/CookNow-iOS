//
//  UICoordinator.swift
//  App
//
//  Created by 쩡화니 on 8/18/24.
//

import SwiftUI
import Auth
import Dependencies
import ComposableArchitecture
import Combine
import Common

final class UICoordinator: Reducer {
    
  // MARK: Dependencies
  @ObservedObject var tokenManager: TokenManager = .shared
  @Dependency(\.mainQueue) private var mainQueue

  private var cancellables: Set<AnyCancellable> = []

  // MARK: State
  struct State {
  }
  
  // MARK: Action
  enum Action {
    case addTokenExpirationObserver
    case handleTokenExpiration
  }
  
  var body: some ReducerOf<UICoordinator> {
    Reduce { state, action in
      switch action {
      case .addTokenExpirationObserver:
        // Use publisher to handle continuous notifications
        return .publisher {
          NotificationCenter.default
            .publisher(for: .tokenExpired)
            .map { _ in Action.handleTokenExpiration }
            
        }
        
      case .handleTokenExpiration:
        // Handle token expiration (e.g., navigate to login, refresh token)
        return .none
      }
    }
  }
}

enum AppRoute {
  case onboarding
  case mainTab
}
