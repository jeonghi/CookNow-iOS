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
  @Dependency(\.authService) private var authService
  
  // MARK: Constructor
  public init() {}
  
  public enum SheetType: Identifiable {
    
    public var id: Self {
        return self
    }
    
    case tos
    case cs
    
    var url: URL? {
      switch self {
      case .cs:
        return Constants.csWebUrl
      case .tos:
        return Constants.tosWebUrl
      }
    }
  }
  
  // MARK: State
  public struct State: Equatable {
    
    var isLoading: Bool
    var alertState: CNAlertState?
    var sheetType: SheetType?
    
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
    case setSheetType(SheetType?)
    case tosButtonTapped
    case csButtonTapped
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
        return .run { _ in
          do {
            try await authService.signOut()
          } catch {
            
          }
        }
        
      case .withdrawlButtonTapped:
        return .run { _ in
          do {
            try await authService.withdrawl()
          } catch {
            
          }
        }
      
      case .csButtonTapped:
        return .run { send in
          await send(.setSheetType(.cs))
        }
        
      case .tosButtonTapped:
        return .run { send in
          await send(.setSheetType(.tos))
        }
        
      case .cancelAlert:
        state.alertState = nil
        return .none
        
      case .updateAlertState(let updated):
        state.alertState = updated
        return .none
        
      case .setSheetType(let type):
        state.sheetType = type
        return .none
        
        // MARK: Networking
      }
    }
  }
}
