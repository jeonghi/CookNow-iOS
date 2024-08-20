//
//  IngredientCategory.swift
//  Domain
//
//  Created by 쩡화니 on 8/18/24.
//

import Foundation

public struct IngredientCategory: Identifiable, Hashable {
  public let id: String
  public let catergoryName: String
  public var ingredients: [Ingredient] = []
  
  public init(
    id: String = UUID().uuidString,
    catergoryName: String,
    ingredients: [Ingredient] = []
  ) {
    self.id = id
    self.catergoryName = catergoryName
    self.ingredients = ingredients
  }
}

public extension IngredientCategory {
  static var dummyDataList: [IngredientCategory] = [
    .init(catergoryName: "과일"),
    .init(catergoryName: "채소"),
    .init(catergoryName: "고기"),
    .init(catergoryName: "수산물"),
    .init(catergoryName: "해산물")
  ]
}
