//
//  Ingredient.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료 모델
public struct Ingredient: Identifiable, Equatable, Hashable {
  
  /// 식재료 id
  public var id: String
  
  /// 식재료 이름
  public let name: String
  public let imageUrl: URL?
  public let category: IngredientCategory.ID?
  public var estimatedExpirationDate: Date?
  
  // MARK: Initializer
  public init(
    id: String? = nil,
    name: String,
    imageUrl: String? = nil,
    category: IngredientCategory.ID? = nil,
    estimatedExpirationDate: Date? = nil
  ) {
    self.init(id: id, name: name, imageUrl: URL(string: imageUrl ?? ""), category: category, estimatedExpirationDate: estimatedExpirationDate)
  }
  
  public init(
    id: String? = nil,
    name: String,
    imageUrl: URL? = nil,
    category: IngredientCategory.ID? = nil,
    estimatedExpirationDate: Date? = nil
  ) {
    self.id = id ?? UUID().uuidString
    self.name = name
    self.imageUrl = imageUrl
    self.category = category
    self.estimatedExpirationDate = estimatedExpirationDate
  }
}

public extension Ingredient {
  static var dummyData: Ingredient {
    .init(
      name: "딸기",
      imageUrl: "https://cooknow-s3-image.s3.ap-northeast-2.amazonaws.com/ingredient/strawberry.png"
    )
  }
}
