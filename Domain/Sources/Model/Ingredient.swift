//
//  Ingredient.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료 모델
public struct Ingredient: Identifiable, Equatable, Hashable {
  
  /// 식재료 id
  public var id: String
  
  /// 식재료 이름
  public let name: String
  
  public let imageUrl: URL?
  
  // MARK: Initializer
  public init(
    id: String = UUID().uuidString,
    name: String,
    imageUrl: String? = nil
  ) {
    self.id = id
    self.name = name
    if let imageUrl {
      self.imageUrl = URL(string: imageUrl)
    } else {
      self.imageUrl = nil
    }
  }
}

public extension Ingredient {
  static var dummyData: Ingredient {
    .init(
      name: "딸기",
      imageUrl: "https://cooknow-s3-image.s3.ap-northeast-2.amazonaws.com/ingredient/strawberry.png"
    )
  }
}
