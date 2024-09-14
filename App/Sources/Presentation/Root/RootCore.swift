//
//  RootCore.swift
//  App
//
//  Created by 쩡화니 on 8/29/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Onboading

struct RootCore: Reducer {

  // MARK: Dependencies
  @Dependency(\.authService) private var authService

  // MARK: Constructor
  init() {}

  // MARK: State
  struct State {
    var isLoading: Bool
    var mainTabState: MainTabCore.State?
    var onboardingState: OnboadingCore.State?
    var splashState: SplashCore.State?
    var coordinatorState: UICoordinator.State = .init()
    var route: AppRoute?

    public init(isLoading: Bool = false) {
      self.isLoading = isLoading
    }
  }

  // MARK: Action
  enum Action {
    case onAppear
    case onDisappear
    case onLoad
    case isLoading(Bool)
    case onSceneActive
    case activeSplash(Bool)
    case updateRoute(AppRoute?)
    case splashAction(SplashCore.Action)
    case mainTabAction(MainTabCore.Action)
    case onboardingAction(OnboadingCore.Action)
    case coordinatorAction(UICoordinator.Action)
  }

  // MARK: Reduce
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear, .onDisappear:
        return .none

      case .onLoad:
        return handleOnLoad()

      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none

      case .onSceneActive:
        return handleSceneActive()

      case .activeSplash(let isActive):
        return handleActiveSplash(&state, isActive)

      case .updateRoute(let updated):
        return handleUpdateRoute(&state, updated)

      case let .splashAction(actions):
        return handleSplashAction(&state, actions)
        
      case let .mainTabAction(actions):
        return handleMainTabAction(&state, actions)

      case let .onboardingAction(actions):
        return handleOnboardingAction(actions)

      case let .coordinatorAction(actions):
        return handleCoordinatorAction(actions)
      }
    }
    .ifLet(\.mainTabState, action: /Action.mainTabAction) {
      MainTabCore()
    }
    .ifLet(\.onboardingState, action: /Action.onboardingAction) {
      OnboadingCore()
    }
    .ifLet(\.splashState, action: /Action.splashAction) {
      SplashCore()
    }
    Scope(state: \.coordinatorState, action: /Action.coordinatorAction) {
      UICoordinator()
    }
  }
}

// MARK: - Helper Functions
extension RootCore {

  private func handleOnLoad() -> Effect<Action> {
    return .run { send in
      await send(.coordinatorAction(.addTokenExpirationObserver))
    }
  }

  private func handleSceneActive() -> Effect<Action> {
    return .run { send in
      await send(.activeSplash(true))
    }
  }

  private func handleActiveSplash(_ state: inout State, _ isActive: Bool) -> Effect<Action> {
    state.splashState = isActive ? .init() : nil
    return .none
  }

  private func handleUpdateRoute(_ state: inout State, _ updated: AppRoute?) -> Effect<Action> {
    
    let oldRoute = state.route
    let newRoute = updated
    
    if oldRoute != newRoute {
      if let updated {
        switch updated {
        case .onboarding:
          state.onboardingState = .init()
          state.mainTabState = nil
        case .mainTab:
          state.mainTabState = .init()
          state.onboardingState = nil
        }
      } else {
        state.onboardingState = nil
        state.mainTabState = nil
      }
      
      state.route = newRoute
    }
    return .none
  }

  private func handleSplashAction(_ state: inout State, _ actions: SplashCore.Action) -> Effect<Action> {
    switch actions {
    case .tokenIsNotValid:
      return .run { send in
        await send(.updateRoute(.onboarding))
        await send(.activeSplash(false))
      }
    case .tokenIsValid:
      return .run { send in
        await send(.updateRoute(.mainTab))
        await send(.activeSplash(false))
      }
    default:
      return .none
    }
  }

  private func handleOnboardingAction(_ actions: OnboadingCore.Action) -> Effect<Action> {
    switch actions {
    case .appleSignInButtonTapped:
      return .run { send in
        do {
          try await authService.appleSignIn()
          await send(.isLoading(true))
          try await authService.cnSignIn()
          await send(.isLoading(false))
          await send(.updateRoute(.mainTab))
        } catch {
          // handle error
        }
      }
    case .googleSignInButtonTapped:
      return .run { send in
        do {
          try await authService.googleSignIn()
          await send(.isLoading(true))
          try await authService.cnSignIn()
          await send(.isLoading(false))
          await send(.updateRoute(.mainTab))
        } catch {
          // handle error
        }
      }
    default:
      return .none
    }
  }
  
  private func handleMainTabAction(_ state: inout State, _ actions: MainTabCore.Action) -> Effect<Action> {
    return .none
  }

  private func handleCoordinatorAction(_ actions: UICoordinator.Action) -> Effect<Action> {
    switch actions {
    case .handleTokenExpiration:
      return .run { send in
        await send(.updateRoute(.onboarding))
      }
    default:
      return .none
    }
  }
}
