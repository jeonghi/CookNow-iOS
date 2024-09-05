//
//  IngredientStorage.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료 보관 모델
/// - 어떤 식재료를, 몇개를, 어떻게 보관하고, 유통기한은 언제인지 대한 정보를 담은 구조체
public struct IngredientStorage: Identifiable, Hashable, Equatable {
  
  public var id: String
  
  /// 보관할 식재료
  public let ingredient: Ingredient
  
  /// 보관 유형
  public var storageType: StorageType
  
  private var _quantity: Int
  
  /// 보관 갯수
  public var quantity: Int {
    get {
      _quantity
    }
    
    set {
      if newValue < 1 {
        _quantity = 1
      } else if newValue > 99 {
        _quantity = 99
      } else {
        _quantity = newValue
      }
    }
  }
  
  private var _expirationDate: Date
  
  /// 보관 만료일
  public var expirationDate: Date {
    get {
      _expirationDate
    }
    set {
      _expirationDate = newValue
    }
  }
  
  // MARK: Initializer
  public init(
    id: String? = nil,
    ingredient: Ingredient,
    storageType: StorageType = .refrigerator,
    quantity: Int = 1,
    expirationDate: Date? = Date()
  ) {
    self.id = id ?? UUID().uuidString
    self.ingredient = ingredient
    self.storageType = storageType
    self._quantity = quantity
    self._expirationDate = expirationDate ?? Date()
  }
  
  var formattedExpirationDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: expirationDate)
  }
}


public extension IngredientStorage {
  static var dummyData: IngredientStorage {
    .init(
      ingredient: .dummyData,
      storageType: .freezer
    )
  }
}
