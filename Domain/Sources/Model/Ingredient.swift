//
//  Ingredient.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation
import Common

/// 식재료 모델
public struct Ingredient: Identifiable, Equatable, Hashable {
  
  /// 식재료 id
  public var id: String
  
  /// 식재료 이름
  public let name: String
  public let imageUrl: URL?
  public let category: IngredientCategory.ID?
  
  // MARK: Initializer
  public init(
    id: String = UUID().uuidString,
    name: String,
    imageUrl: String? = nil,
    category: IngredientCategory.ID? = nil
  ) {
    self.init(id: id, name: name, imageUrl: imageUrl?.asUrl(), category: category)
  }
  
  public init(
    id: String = UUID().uuidString,
    name: String,
    imageUrl: URL? = nil,
    category: IngredientCategory.ID? = nil
  ) {
    self.id = id
    self.name = name
    self.imageUrl = imageUrl
    self.category = category
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
