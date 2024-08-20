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
}

extension IngredientAPI: TargetType {
  
  public var baseURL: String {
    Constants.baseUrl
  }
  
  public var method: Alamofire.HTTPMethod {
    switch self {
    default:
      return .get
    }
  }
  
  public var path: String {
    switch self {
    case .getAllCategories:
      return "/categories"
    case .getAllIngedients:
      return "/category/all/ingredients"
    case .findIngredients(let categoryId):
      return "/category/\(categoryId)/ingredients"
    }
  }
  
  public var header: [String : String] {
    switch self {
    default:
      return [
        HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
      ]
    }
  }
  
  public var parameters: String? {
    nil
  }
  
  public var queryItems: Encodable? {
    nil
  }
  
  public var body: Data? {
    let encoder = JSONEncoder()
    switch self {
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
