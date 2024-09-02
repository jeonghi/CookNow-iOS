//
//  JWTToken.swift
//  Auth
//
//  Created by 쩡화니 on 7/21/24.
//

import Foundation

public struct JWTToken: Codable {
  
  /// 액세스 토큰
  public let accessToken: String
  
  /// 액세스 토큰의 남은 만료시간 (단위: 초)
  let expiresIn: TimeInterval
  
  /// 엑세스 토큰의 만료 시각
  let expiredAt: Date
  
  /// 리프레시 토큰
  public let refreshToken: String
  
  /// 리프레시 토큰의 남은 만료시간 (단위: 초)
  let refreshTokenExpiresIn: TimeInterval
  
  /// 리프레시 토큰의 만료 시각
  let refreshTokenExpiredAt: Date
  
  // MARK: Init
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    
    // JWT 디코딩 및 만료 시간 계산
    if let accessPayload = JWTToken.decodeJWT(accessToken),
       let accessExp = accessPayload["exp"] as? TimeInterval {
        self.expiredAt = Date(timeIntervalSince1970: accessExp)
        self.expiresIn = accessExp - Date().timeIntervalSince1970
    } else {
        self.expiredAt = Date(timeIntervalSince1970: 0)
        self.expiresIn = 0
    }
    
    if let refreshPayload = JWTToken.decodeJWT(refreshToken),
       let refreshExp = refreshPayload["exp"] as? TimeInterval {
        self.refreshTokenExpiredAt = Date(timeIntervalSince1970: refreshExp)
        self.refreshTokenExpiresIn = refreshExp - Date().timeIntervalSince1970
    } else {
        self.refreshTokenExpiredAt = Date(timeIntervalSince1970: 0)
        self.refreshTokenExpiresIn = 0
    }
  }
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    if(lhs.accessToken == rhs.accessToken) {
      return true
    }
    else {
      return false
    }
  }
  
  static func !=(lhs: Self, rhs: Self) -> Bool {
    if(lhs.accessToken != rhs.accessToken) {
      return true
    }
    else {
      return false
    }
  }
  
  /// JWT 복호화
  private static func decodeJWT(_ jwt: String) -> [String: Any]? {
      let segments = jwt.components(separatedBy: ".")
      guard segments.count > 1 else { return nil }

      var base64String = segments[1]
      // Base64 패딩 추가
      let requiredLength = Int(4 * ceil(Float(base64String.count) / 4.0))
      let paddingLength = requiredLength - base64String.count
      if paddingLength > 0 {
          let padding = "".padding(toLength: paddingLength, withPad: "=", startingAt: 0)
          base64String += padding
      }

      guard let data = Data(base64Encoded: base64String) else { return nil }
      return try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
  }
  
  /// 액세스 토큰 만료 여부 반환
  public var isAccessTokenExpired: Bool {
    return Date() >= expiredAt
  }

  /// 리프레시 토큰의 만료 여부를 반환
  public var isRefreshTokenExpired: Bool {
    return Date() >= refreshTokenExpiredAt
  }
}
