//
//  SaveMyIngredientDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/30/24.
//

import Foundation

public enum SaveMyIngredientDTO {
  
  public struct Request: Encodable {
    
    let itemList: [Item]
    
    public init(itemList: [Item]) {
      self.itemList = itemList
    }
    
    public struct Item: Encodable {
      
      let ingredientId: Int
      let quantity: Int
      let expirationDate: Date
      let storageType: StorageType
      
      enum CodingKeys: String, CodingKey {
        case ingredientId
        case quantity
        case expirationDate
        case storageType
      }
      
      public init(ingredientId: String, quantity: Int, expirationDate: Date, storageType: StorageType) {
        self.ingredientId = Int(ingredientId) ?? 1
        self.quantity = quantity
        self.expirationDate = expirationDate
        self.storageType = storageType
      }
      
      // Custom encoding logic for the Item struct
      public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Encode each property manually
        try container.encode(ingredientId, forKey: .ingredientId)
        try container.encode(quantity, forKey: .quantity)
        
        // Custom date encoding
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: expirationDate)
        try container.encode(dateString, forKey: .expirationDate)
        
        try container.encode(storageType, forKey: .storageType)
      }
    }
  }
  
  public struct Response: Decodable {
    
    let userId: Int
    let itemList: [Item]
    
    public struct Item: Decodable {
      
      let ingredientId: Int
      let name: String?
      let quantity: Int
      let expirationDate: Date
      let storageType: String
      let url: URL?
      
      enum CodingKeys: String, CodingKey {
        case ingredientId
        case name
        case quantity
        case expirationDate
        case storageType
        case url
      }
      
      public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredientId = try container.decode(Int.self, forKey: .ingredientId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        quantity = try container.decode(Int.self, forKey: .quantity)
        storageType = try container.decode(String.self, forKey: .storageType)
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
    }
  }
}


public enum StorageType: String, Codable {
  case cold = "COLD"
  case room = "ROOM"
  case freeze = "FREEZE"
}
