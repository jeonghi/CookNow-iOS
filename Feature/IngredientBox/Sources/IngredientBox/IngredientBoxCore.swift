//
//  IngredientBoxCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/14/24.
//

import ComposableArchitecture
import Foundation
import Dependencies
import Domain

public struct IngredientBoxCore: Reducer {
  
  // MARK: Depenedencies
  @Dependency(\.ingredientService) private var ingredientService
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State {
    
    var isLoading: Bool
    var searchText: String = ""
    
    // 선택된 카테고리
    var selectedCategory: IngredientCategory?
    
    var categories: [IngredientCategory] = IngredientCategory.dummyDataList
    
    // 선택된 카테고리의 재료들
    var currCategoryIngredients: [Ingredient] {
      guard let selectedCategory else { return [] }
      return selectedCategory.ingredients
    }
    
    // 담은 재료 박스
    var selectedingredientBox: [Ingredient] = []
    var alertState: AlertState<Action>?
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }
  
  // MARK: Action
  public enum Action {
    /// Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    case updateSearchText(String)
    case selectCategory(IngredientCategory?)
    case putInIngredient(Ingredient)
    case putOutIngredient(Ingredient)
    case updateCategories([IngredientCategory])
    
    /// Networking
    case requestGetAllIngredients
    
    case alertError(Error)
    case updateAlertState(AlertState<Action>?)
  }
  
  private enum CancelID: CaseIterable, Hashable {
    case requestGetAllIngredients
  }
  
  // MARK: Reducer
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .onDisappear:
        return .none
      case .onLoad:
        return .send(.requestGetAllIngredients)
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
        
      case .updateSearchText(let newSearchText):
        state.searchText = newSearchText
        return .none
      case .selectCategory(let selected):
        state.selectedCategory = selected
        return .none
      case .putInIngredient(let ingredient):
        if !state.selectedingredientBox.contains(ingredient) {
          state.selectedingredientBox.append(ingredient)
        }
        return .none
      case .putOutIngredient(let ingredient):
        state.selectedingredientBox.removeAll { $0 == ingredient }
        return .none
      case .updateCategories(let updated):
        state.categories = updated
        return .none
        
        /// Networking
      case .requestGetAllIngredients:
        return .run { send in
          await send(.isLoading(true))
          do {
            let categories = try await ingredientService.getAllCategoriesWithIngredients()
            await send(.updateCategories(categories))
          } catch {
            await send(.alertError(error))
          }
          await send(.isLoading(false))
        }
        .cancellable(id: CancelID.requestGetAllIngredients)
        
      case .alertError(let error):
        
        let alertState = AlertState<Action>.init(
          title: {
            TextState(error.localizedDescription)
          },
          actions: {
            ButtonState(role: .none, action: .send(.updateAlertState(nil))) {
              TextState("확인")
            }
          },
          message: nil
        )
        
        return .send(.updateAlertState(alertState))
        
      case .updateAlertState(let updated):
        state.alertState = updated
        return .none
      }
    }
  }
}

public extension IngredientBoxCore {
}
