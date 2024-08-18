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
    }
  }
  
  public var header: [String : String] {
    switch self {
    case .signIn(let request):
      return [
        HTTPHeader.authorization.rawValue: "Bearer \(request.idToken)",
        HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
      ]
    case .signOut:
      return [
        HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
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
    let encoder = JSONEncoder()
    switch self {
    default:
      return nil
    }
  }
  
  public var sessionType: SessionType {
    switch self {
    case .signIn, .signOut:
      return .Auth
    case .refreshToken:
      return .AuthApi
    }
  }
}
