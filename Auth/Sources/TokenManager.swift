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

public final class TokenManager: TokenManagerType {
  
  public static let shared = TokenManager()
  
  private let AuthTokenKey = "com.cooknow.auth.token"
  
  var token: JWTToken?
  
  private init() {
    _ = getToken()
  }
  
  public func setToken(_ token: JWTToken?) -> JWTToken? {
    Properties.saveCodable(key: AuthTokenKey, data: token)
    return getToken()
  }
  
  public func getToken() -> JWTToken? {
    if let _ = token {
      self.token = Properties.loadCodable(key: AuthTokenKey)
    }
    return self.token
  }
  
  public func deleteToken() {
    Properties.delete(AuthTokenKey)
    self.token = nil
  }
}
