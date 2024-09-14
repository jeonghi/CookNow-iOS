//
//  IngredientInputFormCardListCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 9/14/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Domain

public struct IngredientInputFormCardListCore: Reducer {
  
  public typealias FormCard = IngredientInputFormCardCore
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State: Equatable {
    
    var isLoading: Bool
    var formCardStateList: IdentifiedArrayOf<FormCard.State>
    var scrolledIngredientStorageId: IngredientStorage.ID?
    
    var ingredientStorageList: [IngredientStorage] {
      formCardStateList.map { $0.ingredientStorage }
    }
    
    var dateSelectionSheetState: DateSelectionSheetCore.State?
    var storageTypeSelectionSheetState: StorageTypeSelectionSheetCore.State?
    
    public init(
      isLoading: Bool = false,
      ingredientStorageList: [IngredientStorage] = []
    ) {
      self.isLoading = isLoading
      self.formCardStateList = IdentifiedArray(
        uniqueElements: ingredientStorageList.map { FormCard.State(ingredientStorage: $0) }
      )
      self.scrolledIngredientStorageId = self.formCardStateList.first?.id
    }
  }
  
  // MARK: Action
  public enum Action {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    // MARK: 시트
    // 날짜 선택 시트
    case dateSelectionSheetAction(action: DateSelectionSheetCore.Action)
    // 보관 방법 선택 시트
    case storageSelctionSheetAction(action: StorageTypeSelectionSheetCore.Action)
    // 날짜 선택 시트 상태 업데이트
    case updateDateSelectionSheetState(DateSelectionSheetCore.State?)
    // 보관 선택 시트 상태 업데이트
    case updateStorageTypeSelectionSheetState(StorageTypeSelectionSheetCore.State?)
    
    // MARK: View defined Action
    case formCardAction(id: IngredientStorage.ID, action: FormCard.Action)
    case scrollTo(IngredientStorage.ID?)
    case updateCardState(IngredientStorage.ID, Date?, StorageType?)
    case ingredientStoragesUpdated
    case removeAllIngredients
    
    case onDelete(IndexSet)
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
        // MARK: 시트
        // 날짜 선택 시트
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
        // MARK: View defined Action
      case .scrollTo(let id):
        state.scrolledIngredientStorageId = id
        return .none
      case let .formCardAction(id, cardAction):
        return handleFormCardAction(&state, id: id, cardAction: cardAction)
      case .updateCardState(let id, let date, let type):
        return updateCardState(&state, id: id, date: date, type: type)
      case .removeAllIngredients:
        state.formCardStateList.removeAll()
        return .send(.ingredientStoragesUpdated)
      case .ingredientStoragesUpdated:
        return .none
      case .onDelete(let indexSet):
        for index in indexSet {
          let id = state.formCardStateList[index].id
          state.formCardStateList.remove(id: id)
        }
        return .none
      }
    }
    .ifLet(\.dateSelectionSheetState, action: /Action.dateSelectionSheetAction) {
      DateSelectionSheetCore()
    }
    .ifLet(\.storageTypeSelectionSheetState, action: /Action.storageSelctionSheetAction) {
      StorageTypeSelectionSheetCore()
    }
    .forEach(\.formCardStateList, action: /Action.formCardAction(id:action:)) {
      FormCard()
    }
  }
}

public extension IngredientInputFormCardListCore {
  
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
}

