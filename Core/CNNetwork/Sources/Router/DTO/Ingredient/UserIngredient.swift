//
//  UserIngredient.swift
//  CNNetwork
//
//  Created by 쩡화니 on 9/5/24.
//

import Foundation

public struct UserIngredient: Codable {
  
  public let id: String?
  public let ingredientId: String?
  public let name: String?
  public let quantity: Int
  public let expirationDate: Date
  public let storageType: StorageType
  public let url: URL?
  
  public init(
    id: String? = nil,
    ingredientId: String? = nil,
    name: String? = nil,
    quantity: Int,
    expirationDate: Date,
    storageType: StorageType,
    url: URL? = nil
  ) {
    self.id = id
    self.ingredientId = ingredientId
    self.name = name
    self.quantity = quantity
    self.expirationDate = expirationDate
    self.storageType = storageType
    self.url = url
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case ingredientId
    case name
    case quantity
    case expirationDate
    case storageType
    case url
  }
  
  public init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let numId = try container.decodeIfPresent(Int.self, forKey: .id) {
      id = String(numId)
    } else {
      id = nil
    }
    
    
    if let numIngredientId = try container.decodeIfPresent(Int.self, forKey: .ingredientId) {
      ingredientId = String(numIngredientId)
    } else {
      ingredientId = nil
    }
    
    name = try container.decodeIfPresent(String.self, forKey: .name)
    quantity = try container.decode(Int.self, forKey: .quantity)
    storageType = try container.decode(StorageType.self, forKey: .storageType)
    url = try? container.decode(URL.self, forKey: .url)
    
    let dateString = try container.decode(String.self, forKey: .expirationDate)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    if let date = formatter.date(from: dateString) {
      expirationDate = date
    } else {
      throw DecodingError.dataCorruptedError(forKey: .expirationDate, in: container, debugDescription: "Date string does not match format expected by formatter.")
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    // id와 ingredientId를 Int로 인코딩
    if let id = id, let intId = Int(id) {
        try container.encode(intId, forKey: .id)
    }
    
    if let ingredientId = ingredientId, let intIngredientId = Int(ingredientId) {
        try container.encode(intIngredientId, forKey: .ingredientId)
    }
    
    try container.encode(quantity, forKey: .quantity)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: expirationDate)
    try container.encode(dateString, forKey: .expirationDate)
    
    try container.encode(storageType, forKey: .storageType)
  }
}


public enum StorageType: String, Codable {
  case cold = "COLD"
  case room = "ROOM"
  case freeze = "FREEZE"
}
