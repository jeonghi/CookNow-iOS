//
//  AuthService.swift
//  Setting
//
//  Created by 쩡화니 on 9/13/24.
//

import Foundation
import CNNetwork
import Dependencies
import Auth

protocol AuthServiceType {
  func signOut() async throws
  func withdrawl() async throws
}

struct AuthServiceDependencyKey: DependencyKey {
  static let liveValue: AuthServiceType = AuthServiceImpl.shared
}

extension DependencyValues {
  var authService: AuthServiceType {
    get { self[AuthServiceDependencyKey.self] }
    set { self[AuthServiceDependencyKey.self] = newValue }
  }
}

final class AuthServiceImpl: AuthServiceType {
  private var network: CNNetwork.Network<CNNetwork.AuthAPI>
  
  static let shared: AuthServiceType = AuthServiceImpl()
  private let tokenManager = TokenManager.shared
  
  private init() {
    network = .init()
  }
  
  func signOut() async throws {
    _ = try await network.responseData(.signOut, Box.self)
    await tokenManager.deleteToken()
  }
  
  func withdrawl() async throws {
    _ = try await network.responseData(.withdrawl, Box.self)
    await tokenManager.deleteToken()
  }
}
