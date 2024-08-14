//
//  DateSelectionCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/29/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Domain

public struct DateSelectionSheetCore: Reducer {
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  // MARK: State
  public struct State: Equatable, Identifiable {
    
    public var id: UUID {
      ingredientID
    }
    
    var ingredientID: IngredientStorage.ID
    var selectedDate: Date
    
    public init(ingredientID: IngredientStorage.ID, selection: Date) {
      self.ingredientID = ingredientID
      self.selectedDate = selection
    }
  }
  
  // MARK: Action
  public enum Action {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    
    // MARK: View defined Action
    case cancel
    case confirm(IngredientStorage.ID, Date)
    case cancelButtonTapped
    case confirmButtonTapped
    
    case selectDate(Date)
    
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
        
        // MARK: View defined Action
      case .cancelButtonTapped:
        return .send(.cancel)
      case .confirmButtonTapped:
        return .send(.confirm(state.id, state.selectedDate))
      case .cancel:
        return .none
      case .confirm:
        return .none
        
      case .selectDate(let selectedDate):
        state.selectedDate = selectedDate
        return .none
        
        // MARK: Networking
      }
    }
  }
}

public extension DateSelectionSheetCore {}

