//
//  Mapper.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/20/24.
//

import Foundation

public protocol Mappable {
  associatedtype ModelType
  
  func toModel() -> ModelType
}


final class Mapper<DTO: Mappable> {
  
  public func toModel(dto: DTO) -> DTO.ModelType {
    return dto.toModel()
  }
}
