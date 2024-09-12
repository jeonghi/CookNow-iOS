//
//  StorageTypeSelectionSheetCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 9/12/24.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Domain

public struct StorageTypeSelectionSheetCore: Reducer {
  
  // MARK: Dependencies
  
  // MARK: Constructor
  public init() {
    
  }
  
  public typealias SelectionType = Domain.StorageType
  
  // MARK: State
  public struct State: Equatable, Identifiable {
    
    public var id: String {
      ingredientID
    }
    
    var ingredientID: IngredientStorage.ID
    var selection: SelectionType
    
    public init(ingredientID: IngredientStorage.ID, selection: SelectionType) {
      self.ingredientID = ingredientID
      self.selection = selection
    }
  }
  
  // MARK: Action
  public enum Action {
    // MARK: Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    
    // MARK: View defined Action
    case typeTapped(SelectionType)
    case select(IngredientStorage.ID, SelectionType)
    
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
      case .typeTapped(let selection):
        state.selection = selection
        let id = state.ingredientID
        return .run { send in
          await send(.select(id, selection))
        }
      case .select:
        return .none
      }
    }
  }
}

public extension DateSelectionSheetCore {}

