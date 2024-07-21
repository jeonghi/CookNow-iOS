//
//  TokenManager.swift
//  Auth
//
//  Created by 쩡화니 on 7/21/24.
//

import Foundation
import Common

public protocol TokenManagerType {
  func setToken(_ token: JWTToken?) -> JWTToken?
  func getToken() -> JWTToken?
  func deleteToken()
}

final class TokenManager: TokenManagerType {
  
  public static let shared = TokenManager()
  
  private let AuthTokenKey = "com.cooknow.auth.token"
  
  var token: JWTToken?
  
  private init() {
    _ = getToken()
  }
  
  func setToken(_ token: JWTToken?) -> JWTToken? {
    Properties.saveCodable(key: AuthTokenKey, data: token)
    return getToken()
  }
  
  func getToken() -> JWTToken? {
    if let token {
      self.token = Properties.loadCodable(key: AuthTokenKey)
    }
    return self.token
  }
  
  func deleteToken() {
    Properties.delete(AuthTokenKey)
    self.token = nil
  }
}
