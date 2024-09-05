//
//  IngredientService.swift
//  Refrigerator
//
//  Created by 쩡화니 on 9/5/24.
//

import Foundation
import CNNetwork
import Common
import Dependencies
import Domain

protocol IngredientServiceType {
  func getMyIngredients() async throws -> [IngredientStorage]
}

struct IngredientServiceDependencyKey: DependencyKey {
  static let liveValue: IngredientServiceType = IngredientServiceImpl.shared
  static let testValue: IngredientServiceType = IngredientServiceImpl.shared
}

enum IngredientServiceError: Error {
}

extension DependencyValues {
  var ingredientService: IngredientServiceType {
    get { self[IngredientServiceDependencyKey.self] }
    set { self[IngredientServiceDependencyKey.self] = newValue }
  }
}

final class IngredientServiceMock: IngredientServiceType {
  func getMyIngredients() async throws -> [IngredientStorage] {
    return [.dummyData]
  }
}

final class IngredientServiceImpl: IngredientServiceType {
  private var network: CNNetwork.Network<CNNetwork.IngredientAPI>
  
  static let shared: IngredientServiceType = IngredientServiceImpl()
  
  private init() {
    network = .init()
  }
  
  func getMyIngredients() async throws -> [IngredientStorage] {
    
    let myIngredientsResponse = try await network.responseData(.getMyIngredients, GetMyIngredientDTO.Response.self)
    
    return myIngredientsResponse.itemList.map { $0.toModel() }
  }
  
  func updateMyIngredients(for models: [IngredientStorage]) async throws ->  [IngredientStorage]  {
    
    let itemList: [UserIngredient] = models.map {
      
      let storageType: CNNetwork.StorageType = .init($0.storageType)
      
      return .init(
        id: $0.id,
        quantity: $0.quantity,
        expirationDate: $0.expirationDate,
        storageType: storageType
      )
    }
    
    let updateRequest = UpdateMyIngredientDTO.Request(itemList: itemList)
    
    let myIngredientsResponse = try await network.responseData(
      .updateMyIngredients(updateRequest),
      GetMyIngredientDTO.Response.self
    )
    
    return myIngredientsResponse.itemList.map { $0.toModel() }
  }
}

extension UserIngredient: Mappable {
  
  public typealias ModelType = IngredientStorage
  
  public func toModel() -> Domain.IngredientStorage {
    let ingredient: Ingredient = .init(
      id: self.ingredientId,
      name: self.name ?? "",
      imageUrl: self.url
    )
    
    let storageType: Domain.StorageType = .init(self.storageType)
    
    return .init(
      id: self.id,
      ingredient: ingredient,
      storageType: storageType,
      quantity: self.quantity,
      expirationDate: self.expirationDate
    )
  }
}

extension CNNetwork.StorageType {
  init(_ type: Domain.StorageType) {
    switch type {
    case .freezer:
      self = .freeze
    case .refrigerator:
      self = .cold
    case .roomTemperature:
      self = .room
    }
  }
}

extension Domain.StorageType {
  init(_ type: CNNetwork.StorageType) {
    switch type {
    case .freeze:
      self = .freezer
    case .cold:
      self = .refrigerator
    case .room:
      self = .roomTemperature
    }
  }
}
