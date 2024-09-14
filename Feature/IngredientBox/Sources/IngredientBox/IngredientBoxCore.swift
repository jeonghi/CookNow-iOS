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
  
  // MARK: Dependencies
  @Dependency(\.ingredientService) private var ingredientService
  
  // MARK: Constructor
  public init() {}
  
  public enum Route {
    case inputForm // 폼으로 이동
  }
  
  // MARK: - State
  public struct State {
    
    // 로딩 상태
    var isLoading: Bool
    
    // 검색 관련 상태
    var searchText: String = ""
    
    // 시트 표시 상태
    var showingSheet: Bool = false
    
    // 선택된 카테고리 및 관련 데이터
    var selectedCategory: IngredientCategory?
    var categories: [IngredientCategory] = []
    var ingredients: [Ingredient] {
      categories.flatMap { $0.ingredients }
    }
    
    // 재료 박스
    var selectedingredientBox: Set<Ingredient.ID> = .init()
    var selectedingredients: [Ingredient] {
      let selectedIngedientIds = selectedingredientBox.sorted()
      
      let selectedIngredientList: [Ingredient] = ingredients
        .filter {
          selectedIngedientIds.contains($0.id)
        }
      
      return selectedIngredientList
    }
    
    // 알림 상태
    var alertState: AlertState<Action>?
    
    // 다음 화면 표시 여부
    var route: Route?
    
    // 재료 입력 폼 상태
    var ingredientInputFormState: IngredientInputFormCore.State?
    
    // 현재 선택된 카테고리의 재료 목록
    var currCategoryIngredients: [Ingredient] {
      guard let selectedCategory else { return [] }
      return selectedCategory.ingredients
    }
    
    // State constructor
    public init(isLoading: Bool = false) {
      self.isLoading = isLoading
    }
  }
  
  // MARK: Action
  public enum Action {
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    case setRoute(Route?)
    case showingSheet(Bool)
    case updateSearchText(String)
    case selectCategory(IngredientCategory?)
    case putInOutIngredient(Ingredient)
    case updateCategories([IngredientCategory])
    case ingredientBoxTapped
    case continueSelectionButtonTapped
    case finishSelectionButtonTapped
    case requestGetAllIngredients
    case alertError(Error)
    case updateAlertState(AlertState<Action>?)
    case ingredientInputFormAction(IngredientInputFormCore.Action)
  }
  
  private enum CancelID: CaseIterable, Hashable {
    case requestGetAllIngredients
  }
  
  // MARK: Reducer
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear, .onDisappear:
        return .none
      case .onLoad:
        return handleOnLoad()
      case .isLoading(let isLoading):
        return handleIsLoading(&state, isLoading: isLoading)
      case .setRoute(let route):
        if let route {
          switch route {
          case .inputForm:
            setRouteToInputForm(&state)
          }
        } else {
          
        }
        state.route = route
        return .none
      case .showingSheet(let showing):
        return handleShowingSheet(&state, showing: showing)
      case .updateSearchText(let newSearchText):
        return handleUpdateSearchText(&state, newSearchText: newSearchText)
      case .selectCategory(let selected):
        return handleSelectCategory(&state, selected: selected)
      case .putInOutIngredient(let ingredient):
        return handlePutInOutIngredient(&state, ingredient: ingredient)
      case .updateCategories(let updated):
        return handleUpdateCategories(&state, updated: updated)
      case .ingredientBoxTapped:
        return handleIngredientBoxTapped()
      case .requestGetAllIngredients:
        return handleRequestGetAllIngredients()
      case .alertError(let error):
        return handleAlertError(&state, error: error)
      case .updateAlertState(let updated):
        return handleUpdateAlertState(&state, updated: updated)
      case .continueSelectionButtonTapped:
        return handleContinueSelection()
      case .finishSelectionButtonTapped:
        return handleFinishSelection()
      case .ingredientInputFormAction(let actions):
        return handleInputForm(&state, actions)
      }
    }
    .ifLet(\.ingredientInputFormState, action: /Action.ingredientInputFormAction) {
      IngredientInputFormCore()
    }
  }
}

// MARK: - Helper Functions
extension IngredientBoxCore {
  
  private func setRouteToInputForm(_ state: inout State) {
    
    let selectedIngredientStorageList: [IngredientStorage] = state.selectedingredients
      .map {
        .init(ingredient: $0, expirationDate: $0.estimatedExpirationDate)
      }
    
    state.ingredientInputFormState = .init(ingredientStorageList: selectedIngredientStorageList)
    return
  }
  
  private func handleOnLoad() -> Effect<Action> {
    return .send(.requestGetAllIngredients)
  }
  
  private func handleIsLoading(_ state: inout State, isLoading: Bool) -> Effect<Action> {
    state.isLoading = isLoading
    return .none
  }
  
  private func handleShowingSheet(_ state: inout State, showing: Bool) -> Effect<Action> {
    state.showingSheet = showing
    return .none
  }
  
  private func handleUpdateSearchText(_ state: inout State, newSearchText: String) -> Effect<Action> {
    state.searchText = newSearchText
    return .none
  }
  
  private func handleSelectCategory(_ state: inout State, selected: IngredientCategory?) -> Effect<Action> {
    state.selectedCategory = selected
    return .none
  }
  
  private func handlePutInOutIngredient(_ state: inout State, ingredient: Ingredient) -> Effect<Action> {
    if state.selectedingredientBox.contains(ingredient.id) {
      state.selectedingredientBox.remove(ingredient.id)
    } else {
      state.selectedingredientBox.insert(ingredient.id)
    }
    return .none
  }
  
  private func handleUpdateCategories(_ state: inout State, updated: [IngredientCategory]) -> Effect<Action> {
    state.categories = updated
    return .none
  }
  
  private func handleIngredientBoxTapped() -> Effect<Action> {
    return .run { send in
      await send(.showingSheet(true))
    }
  }
  
  private func handleRequestGetAllIngredients() -> Effect<Action> {
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
  }
  
  private func handleAlertError(_ state: inout State, error: Error) -> Effect<Action> {
    let alertState = AlertState<Action>.init(
      title: { TextState(error.localizedDescription) },
      actions: {
        ButtonState(role: .none, action: .send(.updateAlertState(nil))) {
          TextState("확인")
        }
      },
      message: nil
    )
    return .send(.updateAlertState(alertState))
  }
  
  private func handleUpdateAlertState(_ state: inout State, updated: AlertState<Action>?) -> Effect<Action> {
    state.alertState = updated
    return .none
  }
  
  private func handleContinueSelection() -> Effect<Action> {
    return .run { send in
      await send(.showingSheet(false))
    }
  }
  
  private func handleFinishSelection() -> Effect<Action> {
    return .run { send in
      await send(.setRoute(.inputForm))
      await send(.showingSheet(false))
    }
  }
  
  private func handleInputForm(_ state: inout State, _ action: IngredientInputFormCore.Action) -> Effect<Action> {
    
    switch action {
    case .ingredientInputFormCardListAction(.ingredientStoragesUpdated):
      guard let ingredients = state.ingredientInputFormState?.ingredientStorageList else {
        return .none
      }
      
      let selectedIds = ingredients
        .map { $0.ingredient.id }
      
      state.selectedingredientBox = Set(selectedIds)
      return .none
      
    case .requestSaveMyIngredientsSuccess:
      state.selectedingredientBox.removeAll()
      return .none
    default:
      return .none
    }
  }
}
