//
//  IngredientService.swift
//  IngredientBox
//
//  Created by 쩡화니 on 8/19/24.
//

import Foundation
import CNNetwork
import Common
import Dependencies
import Domain

protocol IngredientServiceType {
  func getAllCategories() async throws -> [IngredientCategory]
  func getAllCategoriesWithIngredients() async throws -> [IngredientCategory]
}

struct IngredientServiceDependencyKey: DependencyKey {
  static let liveValue: IngredientServiceType = IngredientServiceImpl.shared
}

enum IngredientServiceError: Error {
}

extension DependencyValues {
  var ingredientService: IngredientServiceType {
    get { self[IngredientServiceDependencyKey.self] }
    set { self[IngredientServiceDependencyKey.self] = newValue }
  }
}


final class IngredientServiceStub: IngredientServiceType {
  func getAllCategories() async -> [IngredientCategory] {
    return []
  }
  
  func getAllCategoriesWithIngredients() async throws -> [IngredientCategory] {
    return []
  }
}

final class IngredientServiceImpl {
  private var network: CNNetwork.Network<CNNetwork.IngredientAPI>
  
  static let shared: IngredientServiceType = IngredientServiceImpl()
  
  private init() {
    network = .init()
  }
}

extension IngredientServiceImpl: IngredientServiceType {
  
  func getAllCategories() async throws -> [Domain.IngredientCategory] {
    return []
  }
  
  func getAllCategoriesWithIngredients() async throws -> [Domain.IngredientCategory] {
    
    let ingredientDTO = try await network.responseData(.getAllIngedients, IngredientDTO.Response.self)
    
    return ingredientDTO.toModel()
  }
}


extension IngredientDTO.Response: Mappable {
  
  public typealias ModelType = [IngredientCategory]
  
  public func toModel() -> [Domain.IngredientCategory] {
    self
      .map { category in
        
        let ingredients: [Domain.Ingredient] = category.ingredients.map { ingredient in
          return .init(
            id: ingredient.ingredientId,
            name: ingredient.name,
            imageUrl: ingredient.imageUrl,
            category: ingredient.categoryId
          )
        }
        
        return .init(
          id: category.id,
          catergoryName: category.name,
          ingredients: ingredients
        )
      }
  }
  
  public static func fromModel(_ model: [Domain.IngredientCategory]) -> Array<Element> {
    return []
  }
}
