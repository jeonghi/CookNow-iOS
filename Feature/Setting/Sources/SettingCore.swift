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

public struct SettingCore: Reducer {
  
  // MARK: Dependencies
  let tokenManager: TokenManager = .shared
  
  // MARK: Constructor
  public init() {}
  
  // MARK: State
  public struct State: Equatable {
    var isLoading: Bool
    var showingLogoutAlert: Bool
    var showingWithdrawlAlert: Bool
    
    public init(
      isLoading: Bool = false,
      showingLogoutAlert: Bool = false,
      showingWithdrawlAlert: Bool = false
    ) {
      self.isLoading = isLoading
      self.showingLogoutAlert = showingLogoutAlert
      self.showingWithdrawlAlert = showingWithdrawlAlert
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
    case logoutConfirmed
    case withdrawlConfirmed
    case dismissLogoutAlert
    case dismissWithdrawlAlert
    
    // MARK: Networking
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
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
        state.showingLogoutAlert = true
        return .none
        
      case .withdrawlButtonTapped:
        state.showingWithdrawlAlert = true
        return .none
        
      case .logoutConfirmed:
        state.showingLogoutAlert = false
        tokenManager.deleteToken()
        return .none
        
      case .withdrawlConfirmed:
        state.showingWithdrawlAlert = false
        print("User account withdrawn")
        return .none
        
      case .dismissLogoutAlert:
        state.showingLogoutAlert = false
        return .none
        
      case .dismissWithdrawlAlert:
        state.showingWithdrawlAlert = false
        return .none
        
        // MARK: Networking
      }
    }
  }
}
