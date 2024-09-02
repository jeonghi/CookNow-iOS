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
  func saveMyIngredients(ingredientStorage: [IngredientStorage]) async throws
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
  
  func saveMyIngredients(ingredientStorage: [IngredientStorage]) async throws {
    
    let itemList: [SaveMyIngredientDTO.Request.Item] = ingredientStorage.map {
      .init(ingredientId: $0.ingredient.id, quantity: $0.quantity, expirationDate: $0.expirationDate, storageType: .room)
    }
    
    let request: SaveMyIngredientDTO.Request = .init(itemList: itemList)
    
    _ = try await network.responseData(.saveMyIngredients(request), SaveMyIngredientDTO.Response.self)
  }
}


extension IngredientDTO.Response: Mappable {
  
  public typealias ModelType = [IngredientCategory]
  
  public func toModel() -> [Domain.IngredientCategory] {
    self.categories.map { category in
      let ingredients: [Domain.Ingredient] = category.ingredients.map { ingredient in
        return .init(
          id: ingredient.id,
          name: ingredient.name,
          imageUrl: ingredient.imageUrl,
          category: category.id,
          estimatedExpirationDate: ingredient.expirationDate
        )
      }
      
      return .init(
        id: category.id,
        catergoryName: category.name,
        ingredients: ingredients
      )
    }
  }
}
