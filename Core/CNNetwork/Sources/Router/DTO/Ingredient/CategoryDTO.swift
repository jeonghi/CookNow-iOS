//
//  CategoryDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/19/24.
//

import Foundation
import Common

public enum IngredientDTO {
  
  public typealias Response = [Category]
  
  public struct Category: Decodable {
    public let id: String
    public let name: String
    public let ingredients: [Ingredient]
    
    public enum CodingKeys: CodingKey {
      case id
      case name
      case ingredients
    }
    
    public init(id: String, name: String, ingredients: [Ingredient] = []) {
      self.id = id
      self.name = name
      self.ingredients = ingredients
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<IngredientDTO.Category.CodingKeys> = try decoder.container(keyedBy: IngredientDTO.Category.CodingKeys.self)
      self.id = try container.decode(String.self, forKey: IngredientDTO.Category.CodingKeys.id)
      self.name = try container.decode(String.self, forKey: IngredientDTO.Category.CodingKeys.name)
      self.ingredients = try container.decode([IngredientDTO.Ingredient].self, forKey: IngredientDTO.Category.CodingKeys.ingredients)
    }
  }
  
  public struct Ingredient: Decodable {
    public let ingredientId: String
    public let categoryId: String
    public let name: String
    public let imageUrl: URL?
    
    enum CodingKeys: CodingKey {
      case ingredientId
      case categoryId
      case name
      case imageUrl
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<IngredientDTO.Ingredient.CodingKeys> = try decoder.container(keyedBy: IngredientDTO.Ingredient.CodingKeys.self)
      self.ingredientId = try container.decode(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.ingredientId)
      self.categoryId = try container.decode(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.categoryId)
      self.name = try container.decode(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.name)
      self.imageUrl = try container.decodeIfPresent(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.imageUrl)?.asUrl()
    }
  }
}
