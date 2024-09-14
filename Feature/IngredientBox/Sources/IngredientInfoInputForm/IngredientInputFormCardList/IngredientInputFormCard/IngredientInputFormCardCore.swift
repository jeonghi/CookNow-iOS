//
//  IngredientInputFormCardCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/29/24.
//

import Foundation
import ComposableArchitecture
import Domain

public struct IngredientInputFormCardCore: Reducer {
  
  public init() {
    
  }
  
  // MARK: State
  public struct State: Equatable, Identifiable {
    var ingredientStorage: IngredientStorage
    
    public var id: IngredientStorage.ID {
      get {
        ingredientStorage.id
      }
      set {
        ingredientStorage.id = newValue
      }
    }
    
    public init(ingredientStorage: IngredientStorage) {
      self.ingredientStorage = ingredientStorage
    }
  }
  
  // MARK: Action
  public enum Action: Equatable {
    case copyIngredient
    case removeIngredient
    case selectDate
    case updateDate(Date)
    case selectStorageType
    case plusIngredientAmount
    case minusIngredientAmount
  }
  
  // MARK: Reduce
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .copyIngredient:
        return .none
      case .removeIngredient:
        return .none
      case .selectDate:
        return .none
      case .updateDate(let date):
        state.ingredientStorage.expirationDate = date
        return .none
      case .selectStorageType:
        return .none
      case .plusIngredientAmount:
        guard state.ingredientStorage.quantity < 99 else {
          return .none
        }
        state.ingredientStorage.quantity += 1
        return .none
      case .minusIngredientAmount:
        guard state.ingredientStorage.quantity > 1 else {
          return .none
        }
        state.ingredientStorage.quantity -= 1
        return .none
      }
    }
  }
}
