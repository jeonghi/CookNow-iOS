//
//  DeleteMyIngredientDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 9/13/24.
//

import Foundation

public enum DeleteMyIngredientDTO {
  public struct Request: Encodable {
    let ids: [Int]
    
    public init(ids: [Int]) {
      self.ids = ids
    }
  }
  
  public struct Response: Decodable {
    public let ids: [Int]
  }
}
