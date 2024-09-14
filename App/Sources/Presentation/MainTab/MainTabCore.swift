//
//  MainTabCore.swift
//  App
//
//  Created by 쩡화니 on 8/19/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Refrigerator
import IngredientBox
import Setting


public struct MainTabCore: Reducer {
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool
    var refrigeratorState: RefrigeratorHomeCore.State = .init()
    var ingredientBoxState: IngredientBoxCore.State = .init()
    var settingState: SettingCore.State = .init()
    
    var selectedTab: MainTabType = .Refrigerator
    
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
    case selectTab(MainTabType)
    
    // MARK: Networking
    
    // MARK: SubActions
    case refrigeratorAction(RefrigeratorHomeCore.Action)
    case ingredientBoxAction(IngredientBoxCore.Action)
    case settingAction(SettingCore.Action)
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
      case .selectTab(let selected):
        state.selectedTab = selected
        return .none
        
        // MARK: Networking
        
        // MARK: SubActions
      
      case .ingredientBoxAction(.ingredientInputFormAction(.requestSaveMyIngredientsSuccess)):
        state.selectedTab = .Refrigerator
        return .none
      case .ingredientBoxAction:
        return .none
        
      case .refrigeratorAction(let actions):
        if case .refrigeratorTapped = actions {
          state.selectedTab = .IngredientsBox
          return .none
        }
        return .none
      case .settingAction(let actions):
        return .none
      }
    }
    
    Scope(state: \.refrigeratorState, action: /Action.refrigeratorAction) {
      RefrigeratorHomeCore()
    }
    
    Scope(state: \.ingredientBoxState, action: /Action.ingredientBoxAction) {
      IngredientBoxCore()
    }
    
    Scope(state: \.settingState, action: /Action.settingAction) {
      SettingCore()
    }
  }
}

public extension MainTabCore {
}

