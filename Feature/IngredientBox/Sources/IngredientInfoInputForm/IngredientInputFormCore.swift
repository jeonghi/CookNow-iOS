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
  public init() {
    
  }
  
  // MARK: State
  public struct State: Equatable {
    
    var isLoading: Bool
    var formCardStateList: IdentifiedArrayOf<FormCard.State>
    var scrolledIngredientStorageId: IngredientStorage.ID?
    var dateSelectionSheetState: DateSelectionSheetCore.State?
    var isDismiss: Bool = false
    
    var ingredientStorageList: [IngredientStorage] {
      formCardStateList.map {
        $0.ingredientStorage
      }
    }
    
    public init(isLoading: Bool = false, ingredientStorageList: [IngredientStorage] = []) {
      self.isLoading = isLoading
#if(DEBUG)
      self.formCardStateList = IdentifiedArray(
        uniqueElements: ingredientStorageList.map { FormCard.State(ingredientStorage: $0) }
      )
//      self.formCardStateList = [
//        FormCard.State(ingredientStorage: .dummyData),
//        FormCard.State(ingredientStorage: .dummyData)
//      ]
#else
      self.formCardStateList = IdentifiedArray(
        uniqueElements: ingredientStorageList.map { FormCard.State(ingredientStorage: $0) }
      )
#endif
      self.scrolledIngredientStorageId = self.formCardStateList.first?.id
    }
  }
  
  // MARK: Action
  public enum Action {
    
    // MARK: Child Reducer Action
    case formCardAction(id: IngredientStorage.ID, action: FormCard.Action)
    case dateSelectionSheetAction(action: DateSelectionSheetCore.Action)
    case updateDateSelectionSheetState(DateSelectionSheetCore.State?)
    
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    // MARK: View defined Action
    case scrollTo(IngredientStorage.ID?) // 스크롤 이동
    case dismiss
    
    // MARK: Date Selection
    case dateSelectionSheetPresented(IngredientStorage.ID)
    case dateSelectionSheetDismissed
    case dateSelected(Date)
    
    // MARK: New Ingredient
    case addIngredientButtonTapped // 재료 추가 버튼 클릭
    
    // MARK: Done Button Tapped
    case doneButtonTapped
    
    // MARK: Networking
    case requestSaveMyIngredients
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
      case .scrollTo(let id):
        state.scrolledIngredientStorageId = id
        return .none
      case .dismiss:
        state.isDismiss = true
        return .none
        
        // MARK: Date Selection
      case .dateSelectionSheetPresented:
        return .none
      case .dateSelectionSheetDismissed:
        return .none
      case .dateSelected:
        return .none
        
        // MARK: New Ingredient
      case .addIngredientButtonTapped:
        return .run { send in
          await send(.dismiss)
        }
        
        // MARK: Done Button Tapped
      case .doneButtonTapped:
        return .send(.requestSaveMyIngredients)
        
        
        // MARK: Child Reducer Action
      case let .formCardAction(id, cardAction):
        guard let focusedformCardState = state.formCardStateList[id: id], let idx = state.formCardStateList.index(id: id) else {
          return .none
        }
        switch cardAction {
        case .copyIngredient:
          var copiedFormCardState = focusedformCardState
          let newID: String = UUID().uuidString
          copiedFormCardState.id = newID
          state.formCardStateList.insert(copiedFormCardState, at: idx + 1)
          return .send(.scrollTo(newID))
        case .selectStorageType:
          return .none
        case .selectDate:
          state.dateSelectionSheetState = .init(ingredientID: id, selection: focusedformCardState.ingredientStorage.expirationDate)
          return .none
        case .removeIngredient:
          state.formCardStateList.remove(id: id)
          return .none
        default:
          return .none
        }
        
      case let .dateSelectionSheetAction(dateSelectionSheetAction):
        switch dateSelectionSheetAction {
        case .cancel:
          state.dateSelectionSheetState = nil
          return .none
        case .confirm(let id, let selectedDate):
          guard var focusedformCardState = state.formCardStateList[id: id] else {
              return .none
          }
          focusedformCardState.ingredientStorage.expirationDate = selectedDate
          if let idx = state.formCardStateList.index(id: id) {
              state.formCardStateList[idx] = focusedformCardState
          }
          return .none
        default:
          return .none
        }
        
      case let .updateDateSelectionSheetState(updated):
        state.dateSelectionSheetState = updated
        return .none
        
        // MARK: Networking
      case .requestSaveMyIngredients:
        
        let ingredientStorageList = state.ingredientStorageList
        return .run { send in
          await send(.isLoading(true))
          
          do {
            try await ingredientService.saveMyIngredients(ingredientStorage: ingredientStorageList)
            await send(.isLoading(false))
            await send(.dismiss)
          } catch {
            await send(.isLoading(false))
          }
        }
      }
    }
    .forEach(\.formCardStateList, action: /Action.formCardAction(id:action:)) {
      FormCard()
    }
    .ifLet(\.dateSelectionSheetState, action: /Action.dateSelectionSheetAction) {
      DateSelectionSheetCore()
    }
  }
}

public extension IngredientInputFormCore {
}
