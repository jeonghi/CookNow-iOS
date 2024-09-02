//
//  SplashCore.swift
//  App
//
//  Created by 쩡화니 on 8/30/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Common

public struct SplashCore: Reducer {
  
  // MARK: Dependencies
  @Dependency(\.authService) private var authService
  
  // MARK: Constructor
  public init() {}
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }
  
  // MARK: Action
  public enum Action {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    // MARK: View defined Action
    
    // MARK: Networking
    case requestValidateToken
    case tokenIsNotValid
    case tokenIsValid
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
        // MARK: Life Cycle
      case .onAppear:
        return .send(.requestValidateToken)
      case .onDisappear:
        return .none
      case .onLoad:
        return .none
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        // MARK: View defined Action
        
        // MARK: Networking
      case .requestValidateToken:
        return .run { send in
          do {
            try await authService.validateToken()
            CNLog.i("토큰 유효함")
            await send(.tokenIsValid)
          } catch {
            CNLog.i("토큰 유효하지 않음")
            await send(.tokenIsNotValid)
          }
        }
      case .tokenIsNotValid:
        return .none
      case .tokenIsValid:
        return .none
      }
    }
  }
}

public extension SplashCore {
}

