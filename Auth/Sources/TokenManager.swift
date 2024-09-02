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

public final class TokenManager: TokenManagerType, ObservableObject {
  
  public static let shared = TokenManager()
  
  private let AuthTokenKey = "com.cooknow.auth.token"
  
  @Published public var token: JWTToken?
  
  private init() {
    _ = getToken()
  }
  
  @discardableResult
  public func setToken(_ token: JWTToken?) -> JWTToken? {
    Properties.saveCodable(key: AuthTokenKey, data: token)
    let token: JWTToken? = Properties.loadCodable(key: AuthTokenKey)
    self.token = token
    return self.token
  }
  
  public func getToken() -> JWTToken? {
    if token == nil {
      self.token = Properties.loadCodable(key: AuthTokenKey)
    }
    return self.token
  }
  
  public func deleteToken() {
    Properties.delete(AuthTokenKey)
    self.token = nil
    NotificationCenter.default.post(name: .tokenExpired, object: nil)
  }
}
