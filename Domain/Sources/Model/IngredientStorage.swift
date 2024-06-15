//
//  IngredientStorage.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료 보관 모델
/// - 어떤 식재료를, 몇개를, 어떻게 보관하고, 유통기한은 언제인지 대한 정보를 담은 구조체
public struct IngredientStorage: Identifiable {
  
  public let id: UUID
  
  /// 보관할 식재료
  let ingredient: Ingredient
  
  /// 보관 유형
  var storageType: StorageType
  
  /// 보관 갯수
  var quantity: Int
  
  /// 보관 만료일
  var expirationDate: Date
  
  // MARK: Initializer
  public init(
    ingredient: Ingredient,
    storageType: StorageType = .refrigerator,
    quantity: Int = 1,
    expirationDate: Date = Date()
  ) {
    self.id = UUID()
    self.ingredient = ingredient
    self.storageType = storageType
    self.quantity = quantity
    self.expirationDate = expirationDate
  }
  
  var formattedExpirationDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: expirationDate)
  }
}
