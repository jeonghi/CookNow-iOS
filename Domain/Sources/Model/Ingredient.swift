//
//  Ingredient.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료 모델
public struct Ingredient: Identifiable {
  
  /// 식재료 id
  public var id: String
  
  /// 식재료 이름
  public let name: String
  
  // MARK: Initializer
  public init(
    id: String = UUID().uuidString,
    name: String
  ) {
    self.id = id
    self.name = name
  }
}
