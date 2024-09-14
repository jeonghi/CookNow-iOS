//
//  IngredientInputFormCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/24/24.
//

import Foundation
import ComposableArchitecture
import Domain
import IngredientForm

public struct IngredientInputFormCore: Reducer {
  
  // MARK: Dependencies
  @Dependency(\.ingredientService) private var ingredientService
  
  // MARK: Constructor
  public init() {}
  
  // MARK: State
  public struct State: Equatable {
    
    var isLoading: Bool
    var isDismiss: Bool = false
    
    var ingredientInputFormCardListState: IngredientInputFormCardListCore.State
    
    var ingredientStorageList: [IngredientStorage] {
      ingredientInputFormCardListState.ingredientStorageList
    }
    
    public init(isLoading: Bool = false, ingredientStorageList: [IngredientStorage] = []) {
      self.isLoading = isLoading
      ingredientInputFormCardListState = .init(ingredientStorageList: ingredientStorageList)
    }
  }
  
  // MARK: Action
  public enum Action {
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    case dismiss
    
    // MARK: 버튼 이벤트
    case addIngredientButtonTapped // 재료추가 하기 버튼 클릭
    case doneButtonTapped // 완료 버튼 클릭
    
    // MARK: 네트워크
    case requestSaveMyIngredients // 네트워크 요청
    case requestSaveMyIngredientsSuccess
    
    // MARK: 하위 리듀서 액션
    case ingredientInputFormCardListAction(IngredientInputFormCardListCore.Action)
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear, .onDisappear, .onLoad:
        return .none
        
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .dismiss:
        state.isDismiss = true
        return .none
        
        // MARK: 버튼 이벤트
      case .addIngredientButtonTapped:
        return .run { send in
          await send(.dismiss)
        }
        
      case .doneButtonTapped:
        return .send(.requestSaveMyIngredients)
        
        // MARK: 네트워크
      case .requestSaveMyIngredients:
        return requestSaveMyIngredients(&state)
      
      case .requestSaveMyIngredientsSuccess:
        return .none
        
        // MARK: 하위 리듀서 액션
      case .ingredientInputFormCardListAction(let action):
        return .none
      }
    }
    
    Scope(state: \.ingredientInputFormCardListState, action: /Action.ingredientInputFormCardListAction) {
      IngredientInputFormCardListCore()
    }
  }
}

// MARK: - Helper Functions
extension IngredientInputFormCore {
  
  private func requestSaveMyIngredients(_ state: inout State) -> Effect<Action> {
    let ingredientStorageList = state.ingredientStorageList
    return .run { send in
      await send(.isLoading(true))
      do {
        try await ingredientService.saveMyIngredients(ingredientStorage: ingredientStorageList)
        await send(.isLoading(false))
        await send(.requestSaveMyIngredientsSuccess)
        await send(.dismiss)
      } catch {
        await send(.isLoading(false))
      }
    }
  }
}
