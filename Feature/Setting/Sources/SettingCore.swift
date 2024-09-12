//
//  SettingCore.swift
//  Setting
//
//  Created by 쩡화니 on 8/19/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Auth
import DesignSystem

public struct SettingCore: Reducer {
  
  // MARK: Dependencies
  let tokenManager: TokenManager = .shared
  
  // MARK: Constructor
  public init() {}
  
  // MARK: State
  public struct State: Equatable {
    var isLoading: Bool
    var alertState: CNAlertState?
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }
  
  // MARK: Action
  public enum Action: Equatable {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    // MARK: View defined Action
    case logoutButtonTapped
    case withdrawlButtonTapped
    case cancelAlert
    case updateAlertState(CNAlertState?)
    
    // MARK: Networking
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    Reduce {
      state,
      action in
      switch action {
        // MARK: Life Cycle
      case .onAppear:
        return .none
      case .onDisappear:
        return .none
      case .onLoad:
        return .none
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
        // MARK: View defined Action
      case .logoutButtonTapped:
        return .none
        
      case .withdrawlButtonTapped:
        return .none
        
      case .cancelAlert:
        state.alertState = nil
        return .none
        
      case .updateAlertState(let updated):
        state.alertState = updated
        return .none
        
        // MARK: Networking
      }
    }
  }
}
