//
//  IngredientInputFormCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/24/24.
//

import Foundation
import ComposableArchitecture
import Domain

public struct IngredientInputFormCore: Reducer {
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool
    var ingredientStorageList: [IngredientStorage]
    var scrolledIngredientStorageId: IngredientStorage.ID?
    
    public init(isLoading: Bool = false, ingredientStorageList: [IngredientStorage] = []) {
      self.isLoading = isLoading
      #if(DEBUG)
      self.ingredientStorageList = [IngredientStorage.dummyData, IngredientStorage.dummyData]
      #else
      self.ingredientStorageList = ingredientStorageList
      #endif
      self.scrolledIngredientStorageId = self.ingredientStorageList.first?.id
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
    case addIngredientButtonTapped
    case scrollTo(IngredientStorage.ID?)
    case updateIngredientStorageList([IngredientStorage])
    case copyIngredientStorage(IngredientStorage.ID)
    case deleteIngredientStorage(IngredientStorage.ID)
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
      case .addIngredientButtonTapped:
        return .none
      case .scrollTo(let id):
        state.scrolledIngredientStorageId = id
        return .none
      case .updateIngredientStorageList(let updated):
        state.ingredientStorageList = updated
        return .none
      case .copyIngredientStorage(let id):
        guard let index = state.ingredientStorageList.firstIndex(where: { $0.id == id }) else {
          return .none
        }
        guard var copiedIngredient = state.ingredientStorageList[safe: index] else {
          return .none
        }
        copiedIngredient.id = UUID() // 새로운 ID 생성
        state.ingredientStorageList.insert(copiedIngredient, at: index + 1)
        return .send(.scrollTo(copiedIngredient.id))
      case .deleteIngredientStorage(let id):
          state.ingredientStorageList.removeAll { $0.id == id }
          return .none
        // MARK: Networking
      }
    }
  }
}

public extension IngredientInputFormCore {
}
