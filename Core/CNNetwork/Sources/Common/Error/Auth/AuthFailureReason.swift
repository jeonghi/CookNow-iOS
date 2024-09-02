//
//  AuthFailureReason.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

/// 인증 관련 에러 종류
public enum AuthFailureReason: Int, Error, Codable {
  
  /// 유효하지 않은 키
  case InvalidKey = 420
  
  /// 호출 횟수 초과
  case ExcessiveCall = 429
  
  /// 유효하지 않은 URL
  case InvalidUrl = 444
  
  /// 서버 내부 오류
  case InternalServerError = 500
  
  /// 잘못된 요청
  case BadRequest = 400
  
  /// 인증 실패
  case Unauthorized = 401
  
  /// 접근 금지
  case Forbidden = 403
  
  /// 요청 충돌
  case Conflict = 409
  
  /// 리프레시 토큰 만료
  case InvalidRefreshToken = 418
  
  /// 엑세스 토큰 만료
  case InvalidAccessToken = 419
  
  /// 알 수 없음
  case Unknown = -9999
}

extension AuthFailureReason: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .InvalidKey: return "Invalid Key"
    case .ExcessiveCall: return "Excessive Call"
    case .InvalidUrl: return "Invalid URL"
    case .InternalServerError: return "Internal Server Error"
    case .BadRequest: return "Bad Request"
    case .Unauthorized: return "Unauthorized"
    case .Forbidden: return "Forbidden"
    case .Conflict: return "Conflict"
    case .InvalidRefreshToken: return "Refresh Token Expired"
    case .InvalidAccessToken: return "Access Token Expired"
    case .Unknown: return "Unknown Error"
    }
  }
}
