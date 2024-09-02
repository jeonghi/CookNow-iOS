//
//  CNNetworkError.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

public enum CNNetworkError: Error {
  /// 클라이언트에서 발생하는 에러
  case ClientFailed(reason: ClientFailureReason, errorMessage: String?)
  /// API 서버에서 발생하는 에러
  case ApiFailed(reason: ApiFailureReason, errorInfo: ApiErrorInfo?)
  /// 인증 서버에서 발생하는 에러
  case AuthFailed(reason: AuthFailureReason, errorInfo: AuthErrorInfo?)
}


extension CNNetworkError {
  public init(reason: ClientFailureReason = .Unknown, message: String? = nil) {
    switch reason {
    case .ExceedUploadSizeLimit:
      self = .ClientFailed(reason: reason, errorMessage: message ?? "failed to send file because it exceeds the file size limit.")
    case .Cancelled:
      self = .ClientFailed(reason: reason, errorMessage:message ?? "user cancelled")
    case .NotSupported:
      self = .ClientFailed(reason: reason, errorMessage:message ?? "target app is not installed.")
    case .BadParameter:
      self = .ClientFailed(reason: reason, errorMessage:message ?? "bad parameters.")
    case .TokenNotFound:
      self = .ClientFailed(reason: reason, errorMessage: message ?? "authentication tokens not exist.")
    case .CastingFailed:
      self = .ClientFailed(reason: reason, errorMessage: message ?? "casting failed.")
    case .IllegalState:
      self = .ClientFailed(reason: reason, errorMessage:message ?? "illegal state.")
    case .Unknown:
      self = .ClientFailed(reason: reason, errorMessage:message ?? "unknown error.")
    }
  }
}

extension CNNetworkError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .ClientFailed(_, let errorMessage):
      var message = "Client Failure: \(errorMessage ?? "unknown error.")"
      return message
    case .ApiFailed(let reason, let errorInfo):
      var message = "API Failure: \(reason.localizedDescription)"
      if let info = errorInfo {
        message += ", Info: \(info.message)"
      }
      return message
    case .AuthFailed(let reason, let errorInfo):
      var message = "Authentication Failure: \(reason.localizedDescription)"
      if let info = errorInfo {
        message += ", Info: \(info.message)"
      }
      return message
    }
  }
}

extension CNNetworkError {
  
  /// api 타입에 따라 분기해서 에러를 분류하는 생성자
  init?(response: HTTPURLResponse, data: Data, type: ApiType) {
    
    if 200 ..< 300 ~= response.statusCode { return nil }
    
    switch type {
    case .CNApi:
      if let reason = ApiFailureReason(rawValue: response.statusCode), let errorInfo = try? JSONDecoder().decode(ApiErrorInfo.self, from: data){
        self = .ApiFailed(reason: reason, errorInfo: errorInfo)
      }
      else {
        return nil
      }
    case .CNAuth:
      if let reason = AuthFailureReason(rawValue: response.statusCode), let errorInfo = try? JSONDecoder().decode(AuthErrorInfo.self, from: data){
        self = .AuthFailed(reason: reason, errorInfo: errorInfo)
      }
      else {
        return nil
      }
    }
  }
}


extension CNNetworkError {
  
  public var isApiFailed: Bool {
    if case .ApiFailed = self {
      return true
    }
    return false
  }
  
  public var isAuthFailed: Bool {
    if case .AuthFailed = self {
      return true
    }
    return false
  }
  
  /// API 요청 에러에 대한 정보를 얻습니다. `isApiFailed`가 true인 경우 사용해야 합니다.
  /// ## SeeAlso
  /// - ``ApiFailureReason``
  /// - ``ErrorInfo``
  public func getApiError() -> (reason: ApiFailureReason, info: ApiErrorInfo?) {
    if case let .ApiFailed(reason, info) = self {
      return (reason, info)
    }
    return (ApiFailureReason.Unknown, nil)
  }
  
  /// 로그인 요청 에러에 대한 정보를 얻습니다. `isAuthFailed`가 true인 경우 사용해야 합니다.
  /// ## SeeAlso
  /// - ``AuthFailureReason``
  /// - ``AuthErrorInfo``
  public func getAuthError() -> (reason: AuthFailureReason, info: AuthErrorInfo?) {
    if case let .AuthFailed(reason, info) = self {
      return (reason, info)
    }
    return (AuthFailureReason.Unknown, nil)
  }
  
  /// 유효하지 않은 토큰 에러인지 체크합니다.
  public func isInvalidTokenError() -> Bool {
    if case .ApiFailed = self, getApiError().reason == .Unauthorized {
      return true
    }
    else if case .AuthFailed = self, getAuthError().reason == .Unauthorized {
      return true
    }
    
    return false
  }
}
