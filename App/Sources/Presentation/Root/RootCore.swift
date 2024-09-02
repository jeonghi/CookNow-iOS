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
  init() {
    
  }
  
  // MARK: State
  struct State {
    
    var isLoading: Bool
    
    var splashState: SplashCore.State?
    var mainTabState: MainTabCore.State?
    var onboardingState: OnboadingCore.State?
    
    var coordinatorState: UICoordinator.State = .init()
    var route: AppRoute { coordinatorState.route }
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }

  
  // MARK: Action
 enum Action {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    // MARK: View defined Action
   
    // MARK: Networking
    
    // MARK: Child Reducer action
    case splashAction(SplashCore.Action)
    case mainTabAction(MainTabCore.Action)
    case onboardingAction(OnboadingCore.Action)
    
    // MARK: Shared Reducer action
    case coordinatorAction(UICoordinator.Action)
  }
  
  // MARK: Reduce
  var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
        // MARK: Life Cycle
      case .onAppear:
        return .run { send in
          await send(.coordinatorAction(.addTokenExpirationObserver))
          await send(.coordinatorAction(.updateRoute(.splash)))
        }
      case .onDisappear:
        return .none
      case .onLoad:
        return .none
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        // MARK: View defined Action
        
        // MARK: Networking
        
        // MARK: Childe Reducer action
      case .splashAction(let actions):
        switch actions {
        case .tokenIsNotValid: // 토큰이 유효하지 않으면 온보딩으로
          return .run { send in
            await send(.coordinatorAction(.updateRoute(.onboarding)))
          }
        case .tokenIsValid: // 토큰이 유효하면 메인탭으로
          return .run { send in
            await send(.coordinatorAction(.updateRoute(.mainTab)))
          }
        default:
          return .none
        }
      case .onboardingAction(let actions):
        switch actions {
        case .appleSignInButtonTapped:
          return .run { send in
            do {
              try await authService.appleSignIn()
              await send(.coordinatorAction(.updateRoute(.mainTab)))
            } catch {
              
            }
          }
        case .googleSignInButtonTapped:
          return .run { send in
            do {
              try await authService.googleSignIn()
              await send(.coordinatorAction(.updateRoute(.mainTab)))
            } catch {
              
            }
          }
        default:
          return .none
        }
      case .mainTabAction(let actions):
        return .none
        
        // MARK: Shared Reducer action
      case .coordinatorAction(let coordinatorAction):
        if case let .updateRoute(route) = coordinatorAction {
          switch route {
          case .splash:
            state.splashState = .init()
            state.onboardingState = nil
            state.mainTabState = nil
            return .none
          case .onboarding:
            state.onboardingState = .init()
            state.splashState = nil
            state.mainTabState = nil
            return .none
          case .mainTab:
            state.mainTabState = .init()
            state.onboardingState = nil
            state.splashState = nil
            return .none
          }
        }
        return .none
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

extension RootCore {
}

