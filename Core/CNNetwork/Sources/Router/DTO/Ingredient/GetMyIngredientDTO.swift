//
//  GetMyIngredientDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 9/5/24.
//

import Foundation

public enum GetMyIngredientDTO {
  
  public struct Response: Decodable {
    public let userId: Int
    public let itemList: [UserIngredient]
  }
}
