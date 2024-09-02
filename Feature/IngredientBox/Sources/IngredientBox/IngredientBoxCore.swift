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
    var showingSheet: Bool = false
    
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
    
    var showingNext: Bool = false
    
    var ingredientInputFormState: IngredientInputFormCore.State?
    
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
    
    case showingNext(Bool)
    case showingSheet(Bool)
    case updateSearchText(String)
    case selectCategory(IngredientCategory?)
    case putInIngredient(Ingredient)
    case putOutIngredient(Ingredient)
    case updateCategories([IngredientCategory])
    case ingredientBoxTapped
    case continueSelectionButtonTapped
    case finishSelectionButtonTapped
    
    /// Networking
    case requestGetAllIngredients
    
    case alertError(Error)
    case updateAlertState(AlertState<Action>?)
    
    /// Sub Reducer
    case ingredientInputFormAction(IngredientInputFormCore.Action)
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
        
        
      case .showingNext(let showing):
        
        if showing {
          let ingredientStorageList: [IngredientStorage] = state.selectedingredientBox.map {
            .init(ingredient: $0, expirationDate: $0.estimatedExpirationDate)
          }
          
          state.ingredientInputFormState = .init(ingredientStorageList: ingredientStorageList)
        } else {
          state.ingredientInputFormState = nil
        }
        
        state.showingNext = showing
        return .none
        
      case .showingSheet(let showing):
        state.showingSheet = showing
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
      case .ingredientBoxTapped:
        return .run { send in
          await send(.showingSheet(true))
        }
        /// Networking
      case .requestGetAllIngredients:
        return .run { send in
          await send(.isLoading(true))
          do {
            let categories = try await ingredientService.getAllCategoriesWithIngredients()
            await send(.updateCategories(categories))
            await send(.selectCategory(categories.first))
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
      case .continueSelectionButtonTapped:
        return .run { send in
          await send(.showingSheet(false))
        }
      case .finishSelectionButtonTapped:
        
        return .run { send in
          await send(.showingNext(true))
          await send(.showingSheet(false))
        }
        
      case .ingredientInputFormAction(let actions):
        return .none
      }
    }
    .ifLet(\.ingredientInputFormState, action: /Action.ingredientInputFormAction) {
      IngredientInputFormCore()
    }
  }
}

public extension IngredientBoxCore {
}
