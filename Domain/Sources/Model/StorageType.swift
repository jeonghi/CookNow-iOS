//
//  StorageType.swift
//  Domain
//
//  Created by 쩡화니 on 6/15/24.
//

import Foundation

/// 식재료의 보관 타입을 나타내는 열거형
public enum StorageType: String, CaseIterable, Hashable, Equatable  {
  
  /// 실온
  case roomTemperature
  
  /// 냉장
  case refrigerator
  
  /// 냉동
  case freezer
}
