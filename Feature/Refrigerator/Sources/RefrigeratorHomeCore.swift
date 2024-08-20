//
//  RefrigeratorHomeCore.swift
//  Refrigerator
//
//  Created by 쩡화니 on 8/18/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Domain

public struct RefrigeratorHomeCore: Reducer {
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool = false
    var categories: [IngredientCategory] = []
    var ingredients: [Ingredient] = []
    
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
    case refrigeratorTapped // 냉장고 탭 함
    
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
      case .refrigeratorTapped:
        return .none
        // MARK: Networking
      }
    }
  }
}

public extension RefrigeratorHomeCore {
}

