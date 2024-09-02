//
//  CategoryDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/19/24.
//

import Foundation
import Common

public enum IngredientDTO {
  
  public struct Response: Decodable {
    
    public let categories: [IngredientDTO.Category]
    
    enum CodingKeys: String, CodingKey {
      case categories = "categoryList"
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.categories = try container.decode([Category].self, forKey: .categories)
    }
  }
  
  public struct Category: Decodable {
    
    public let id: String
    public let name: String
    public let ingredients: [Ingredient]
    
    public enum CodingKeys: String, CodingKey {
      case id
      case name
      case ingredients = "ingredientList"
    }
    
    public init(id: String, name: String, ingredients: [Ingredient] = []) {
      self.id = id
      self.name = name
      self.ingredients = ingredients
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<IngredientDTO.Category.CodingKeys> = try decoder.container(keyedBy: IngredientDTO.Category.CodingKeys.self)
      let id = try container.decode(Int.self, forKey: IngredientDTO.Category.CodingKeys.id)
      self.id = String(id)
      self.name = try container.decode(String.self, forKey: IngredientDTO.Category.CodingKeys.name)
      self.ingredients = try container.decode([IngredientDTO.Ingredient].self, forKey: IngredientDTO.Category.CodingKeys.ingredients)
    }
  }
  
  public struct Ingredient: Decodable {
    
    public let id: String
    public let name: String
    public let imageUrl: URL?
    public let expirationDate: Date
    
    enum CodingKeys: String, CodingKey {
      case id
      case name
      case imageUrl
      case expirationDate
    }
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<IngredientDTO.Ingredient.CodingKeys> = try decoder.container(keyedBy: IngredientDTO.Ingredient.CodingKeys.self)
      let id = try container.decode(Int.self, forKey: IngredientDTO.Ingredient.CodingKeys.id)
      self.id = String(id)
      self.name = try container.decode(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.name)
      self.imageUrl = try container.decodeIfPresent(String.self, forKey: IngredientDTO.Ingredient.CodingKeys.imageUrl)?.asUrl()
      let daysToAdd = try container.decode(Int.self, forKey: .expirationDate)
      self.expirationDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date()) ?? Date()
    }
  }
}
