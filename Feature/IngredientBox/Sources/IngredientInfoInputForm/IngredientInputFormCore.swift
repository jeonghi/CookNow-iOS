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
  
  public typealias FormCard = IngredientInputFormCardCore
  
  // MARK: Dependencies
  @Dependency(\.ingredientService) private var ingredientService
  
  // MARK: Constructor
  public init() {}
  
  // MARK: State
  public struct State: Equatable {
    
    var isLoading: Bool
    var scrolledIngredientStorageId: IngredientStorage.ID?
    var dateSelectionSheetState: DateSelectionSheetCore.State?
    var storageTypeSelectionSheetState: StorageTypeSelectionSheetCore.State?
    var isDismiss: Bool = false
    var formCardStateList: IdentifiedArrayOf<FormCard.State>
    
    var ingredientStorageList: [IngredientStorage] {
      formCardStateList.map { $0.ingredientStorage }
    }
    
    public init(isLoading: Bool = false, ingredientStorageList: [IngredientStorage] = []) {
      self.isLoading = isLoading
      self.formCardStateList = IdentifiedArray(
        uniqueElements: ingredientStorageList.map { FormCard.State(ingredientStorage: $0) }
      )
      self.scrolledIngredientStorageId = self.formCardStateList.first?.id
    }
  }
  
  // MARK: Action
  public enum Action {
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    case scrollTo(IngredientStorage.ID?)
    case dismiss
    case updateCardState(IngredientStorage.ID, Date?, StorageType?)
    case addIngredientButtonTapped
    case doneButtonTapped
    case requestSaveMyIngredients
    case removeAllIngredients
    case formCardAction(id: IngredientStorage.ID, action: FormCard.Action)
    case dateSelectionSheetAction(action: DateSelectionSheetCore.Action)
    case storageSelctionSheetAction(action: StorageTypeSelectionSheetCore.Action)
    case updateDateSelectionSheetState(DateSelectionSheetCore.State?)
    case updateStorageTypeSelectionSheetState(StorageTypeSelectionSheetCore.State?)
    case ingredientStoragesUpdated
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
        
      case .scrollTo(let id):
        state.scrolledIngredientStorageId = id
        return .none
        
      case .dismiss:
        state.isDismiss = true
        return .none
        
      case .updateCardState(let id, let date, let type):
        return updateCardState(&state, id: id, date: date, type: type)
        
      case .addIngredientButtonTapped:
        return .run { send in
          await send(.dismiss)
        }
        
      case .doneButtonTapped:
        return .send(.requestSaveMyIngredients)
        
      case let .formCardAction(id, cardAction):
        return handleFormCardAction(&state, id: id, cardAction: cardAction)
        
      case let .dateSelectionSheetAction(dateSelectionSheetAction):
        return handleDateSelectionSheetAction(&state, dateSelectionSheetAction: dateSelectionSheetAction)
        
      case let .storageSelctionSheetAction(action):
        return handleStorageSelectionSheetAction(&state, action: action)
        
      case let .updateDateSelectionSheetState(updated):
        state.dateSelectionSheetState = updated
        return .none
        
      case let .updateStorageTypeSelectionSheetState(updated):
        state.storageTypeSelectionSheetState = updated
        return .none
        
      case .requestSaveMyIngredients:
        return requestSaveMyIngredients(&state)
        
      case .removeAllIngredients:
        state.formCardStateList.removeAll()
        return .send(.ingredientStoragesUpdated)
        
      case .ingredientStoragesUpdated:
        return .none
      }
    }
    .forEach(\.formCardStateList, action: /Action.formCardAction(id:action:)) {
      FormCard()
    }
    .ifLet(\.dateSelectionSheetState, action: /Action.dateSelectionSheetAction) {
      DateSelectionSheetCore()
    }
    .ifLet(\.storageTypeSelectionSheetState, action: /Action.storageSelctionSheetAction) {
      StorageTypeSelectionSheetCore()
    }
  }
}

// MARK: - Helper Functions
extension IngredientInputFormCore {
  
  private func updateCardState(
    _ state: inout State,
    id: IngredientStorage.ID,
    date: Date?,
    type: StorageType?
  ) -> Effect<Action> {
    guard var targetState = state.formCardStateList[id: id] else {
      return .none
    }
    
    if let date {
      targetState.ingredientStorage.expirationDate = date
    }
    
    if let type {
      targetState.ingredientStorage.storageType = type
    }
    
    state.formCardStateList.updateOrAppend(targetState)
    return .run { send in
      await send(.ingredientStoragesUpdated)
    }
  }
  
  private func handleFormCardAction(
    _ state: inout State,
    id: IngredientStorage.ID,
    cardAction: FormCard.Action
  ) -> Effect<Action> {
    guard let focusedformCardState = state.formCardStateList[id: id],
          let idx = state.formCardStateList.index(id: id) else {
      return .none
    }
    
    switch cardAction {
    case .copyIngredient:
      var copiedFormCardState = focusedformCardState
      copiedFormCardState.id = UUID().uuidString
      state.formCardStateList.insert(copiedFormCardState, at: idx + 1)
      return .send(.scrollTo(copiedFormCardState.id))
      
    case .selectStorageType:
      return .run { send in
        await send(.updateStorageTypeSelectionSheetState(
          .init(ingredientID: id, selection: focusedformCardState.ingredientStorage.storageType)
        ))
      }
      
    case .selectDate:
      return .run { send in
        await send(.updateDateSelectionSheetState(
          .init(ingredientID: id, selection: focusedformCardState.ingredientStorage.expirationDate)
        ))
      }
      
    case .removeIngredient:
      state.formCardStateList.remove(id: id)
      return .send(.ingredientStoragesUpdated)
      
    default:
      return .none
    }
  }
  
  private func handleDateSelectionSheetAction(
    _ state: inout State,
    dateSelectionSheetAction: DateSelectionSheetCore.Action
  ) -> Effect<Action> {
    switch dateSelectionSheetAction {
    case .cancel:
      return .run { send in
        await send(.updateDateSelectionSheetState(nil))
      }
      
    case .confirm(let id, let selectedDate):
      return .run { send in
        await send(.updateCardState(id, selectedDate, nil))
        await send(.updateDateSelectionSheetState(nil))
      }
      
    default:
      return .none
    }
  }
  
  private func handleStorageSelectionSheetAction(
    _ state: inout State,
    action: StorageTypeSelectionSheetCore.Action
  ) -> Effect<Action> {
    if case let .select(id, selectedType) = action {
      return .run { send in
        await send(.updateCardState(id, nil, selectedType))
      }
    }
    return .none
  }
  
  private func requestSaveMyIngredients(_ state: inout State) -> Effect<Action> {
    let ingredientStorageList = state.ingredientStorageList
    return .run { send in
      await send(.isLoading(true))
      do {
        try await ingredientService.saveMyIngredients(ingredientStorage: ingredientStorageList)
        await send(.isLoading(false))
        await send(.removeAllIngredients)
        await send(.dismiss)
      } catch {
        await send(.isLoading(false))
      }
    }
  }
}
