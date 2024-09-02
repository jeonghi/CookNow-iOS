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
    var route: AppRoute = .splash
  }
  
  // MARK: Action
  enum Action {
    case addTokenExpirationObserver
    case handleTokenExpiration
    case updateRoute(AppRoute)
  }
  
  var body: some ReducerOf<UICoordinator> {
    Reduce { state, action in
      switch action {
        
      case .addTokenExpirationObserver:
        return .publisher {
          Future { callback in
            NotificationCenter.default
              .publisher(for: .tokenExpired)
              .sink { _ in
                callback(.success(.handleTokenExpiration))
              }
              .store(in: &self.cancellables)
          }
         }
        
      case .handleTokenExpiration:
        return .send(.updateRoute(.onboarding))
        
      case let .updateRoute(route):
        state.route = route
        return .none
      }
    }
  }
}

enum AppRoute {
  case splash
  case onboarding
  case mainTab
}
