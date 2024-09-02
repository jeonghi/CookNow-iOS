//
//  IngredientAPI.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/18/24.
//

import Foundation
import Alamofire

public enum IngredientAPI {
  case getAllCategories
  case getAllIngedients
  case findIngredients(categoryId: String)
  case saveMyIngredients(SaveMyIngredientDTO.Request)
  case getMyIngredients(StorageType)
}

extension IngredientAPI: TargetType {
  
  public var baseURL: String {
    Constants.baseUrl + "/api/v1"
  }
  
  public var method: Alamofire.HTTPMethod {
    switch self {
    case .saveMyIngredients:
      return .post
    default:
      return .get
    }
  }
  
  public var path: String {
    switch self {
    case .getAllCategories:
      return "/categories"
    case .getAllIngedients:
      return "/categories/ingredients"
    case .findIngredients(let categoryId):
      return "/category/\(categoryId)/ingredients"
    case .saveMyIngredients:
      return "/user/3/items"
    case .getMyIngredients(let storageType):
      return "/user/3/items?type=\(storageType.rawValue)"
    }
  }
  
  public var header: [String : String] {
    switch self {
    default:
      return [:]
    }
  }
  
  public var parameters: String? {
    nil
  }
  
  public var queryItems: Encodable? {
    nil
  }
  
  public var body: Data? {
    switch self {
    case .saveMyIngredients(let ingredients):
      return try? JSONEncoder().encode(ingredients)
    default:
      return nil
    }
  }
  
  public var sessionType: SessionType {
    switch self {
    default:
      return .AuthApi
    }
  }
}
