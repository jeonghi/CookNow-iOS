//
//  AuthAPI.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation
import Alamofire

public enum AuthAPI {
  /// 로그인
  case signIn(SignInDTO.Request)
  /// 로그아웃
  case signOut
  /// 토큰 갱신하기
  case refreshToken
  /// 토큰 검증하기
  case validateToken
  /// 회원탈퇴하기
  case withdrawl
}

extension AuthAPI: TargetType {
  
  public var baseURL: String {
    Constants.authBaseUrl
  }
  
  public var method: Alamofire.HTTPMethod {
    switch self {
    case .signIn:
      return .post
    case .signOut:
      return .post
    case .refreshToken:
      return .post
    case .validateToken:
      return .post
    case .withdrawl:
      return .delete
    }
  }
  
  public var path: String {
    switch self {
    case .signIn:
      return "/oauth/sign-in"
    case .signOut:
      return "/oauth/sign-out"
    case .refreshToken:
      return "/oauth/refresh"
    case .validateToken:
      return "/oauth/verify-token"
    case .withdrawl:
      return "/oauth/withdraw"
    }
  }
  
  public var header: [String : String] {
    switch self {
    case .signIn(let request):
      return [
        HTTPHeader.authorization.rawValue: "Bearer \(request.idToken)",
      ]
    default:
      return [:]
    }
  }
  
  public var parameters: String? {
    nil
  }
  
  public var queryItems: Encodable? {
    nil
  }
  
  public var body: Data? {
    return nil
  }
  
  public var sessionType: SessionType {
    switch self {
    case .signIn, .refreshToken:
      return .Auth
    case .signOut, .validateToken, .withdrawl:
      return .AuthApi
    }
  }
}
