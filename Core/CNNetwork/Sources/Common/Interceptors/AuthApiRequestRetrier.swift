//
//  AuthApiRequestRetrier.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/29/24.
//

import Foundation
import Alamofire
import Common
import Auth

/// request가 실패했을 때 호출되는 메서드. 인증에러에 대해 요청을 재시도할지 결정.
final class AuthApiRequestRetrier: RequestInterceptor {
  
  private var tokenManager: TokenManager = .shared
  private var requestsToRetry: [(RetryResult) -> Void] = [] /// 재시도를 대기 중인 요청들의 completionHandler를 저장하는 배열.
  private var isRefreshing = false /// 토큰 새로고침 중인지 상태를 나타냄. 새로고침 중에는 중복된 새로고침 요청 방지.
  private var errorLock = NSLock() /// locking 용도
  
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ){
    
    /// locking으로 synchronize
    errorLock.lock(); defer { errorLock.unlock() }
    
    var logString = "request retrier:"
    
    if let commonError = API.getCommonError(error: error) {
      if !commonError.isApiFailed {
        CNLog.e("\(logString)\n error:\(error)\n not api error -> pass through\n\n")
        completion(.doNotRetryWithError(commonError))
        return
      }
      
      switch(commonError.getApiError().reason) {
      case .Unauthorized, .InvalidAccessToken: /// 유효하지 않은 토큰인 경우
        logString = "\(logString)\n reason:\(error)\n token: \(String(describing: tokenManager.getToken()))"
        CNLog.e("\(logString)\n\n")
        
        /// 토큰을 refresh 해야하는지 판단
        if shouldRefreshToken {
          
          /// 액세스 토큰 인증 요청이 아니라면, 재시도를 대기중인 리스트 큐에 넣어둠.
          if let urlString = request.request?.url?.absoluteString, urlString.hasSuffix(AuthAPI.refreshToken.baseURL) == false {
            requestsToRetry.append(completion)
          }
          
          guard let refreshToken = tokenManager.getToken()?.refreshToken else {
            return
          }
          
          /// 갱신 요청중 여부 확인
          if !isRefreshing {
            isRefreshing = true
            
            AUTH_API.responseData(.refreshToken, TokenRefreshDTO.Response.self) { result in
              defer {
                self.requestsToRetry.removeAll() /// 모든 completion 정리
                self.isRefreshing = false
              }
              switch result {
              case .success(_):
                /// 토큰 refresh 성공
                /// 대기중이던 재시도 요청들 재시도 재개함.
                self.requestsToRetry.forEach {
                  $0(.retry)
                }
              case .failure(let error):
                /// 토큰 refresh 실패
                CNLog.e("refreshToken error: \(error). retry aborted.\n request: \(request) \n\n")
                CNLog.i("token expired")
                
                /// 토큰 Expire 알림
                NotificationCenter.default.post(name: .tokenExpired, object: nil)
                
                /// 대기중이던 재시도 요청들 모두 cancel 시킴.
                self.requestsToRetry.forEach {
                  $0(.doNotRetryWithError(error))
                }
              }
            }
          }
        } else {
          let commonError = CNNetworkError(reason: .TokenNotFound) /// refresh 토큰이 존재하지 않음.
          CNLog.e(" should not refresh: \(commonError)  -> pass through \n")
          completion(.doNotRetryWithError(commonError))
          
          NotificationCenter.default.post(name: .tokenExpired, object: nil)
        }
        
      default: /// 기타 에러인경우
        CNLog.e("\(logString)\n reason:\(commonError)\n not handled error -> pass through \n\n")
        completion(.doNotRetryWithError(commonError))
      }
    }
    else {
      CNLog.e("\(logString)\n not handled error -> pass through \n\n")
      completion(.doNotRetry)
    }
  }

  /// 토큰 새로고침
  var shouldRefreshToken: Bool {
    
    /// refresh 토큰 존재 여부 확인후, 존재하지 않으면 로그를 남기고 재시도를 중단.
    guard tokenManager.getToken()?.refreshToken != nil else {
      CNLog.e("refresh token not exist. retry aborted.\n\n")
      return false
    }
    
    return true
  }
}

let AUTH_API = Network<AuthAPI>()
