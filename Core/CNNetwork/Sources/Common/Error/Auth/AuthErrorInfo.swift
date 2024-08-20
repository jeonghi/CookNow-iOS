//
//  AuthErrorInfo.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

/// AuthAPI 호출 시 발생하는 에러 정보입니다.
/// ## SeeAlso
/// - ``AuthFailureReason``
struct AuthErrorInfo: Codable {
  
  /// 에러 메시지
  let message: String
  
  init(
    message: String
  ) {
    self.message = message
  }
}
