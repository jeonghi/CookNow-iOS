//
//  AuthApiRequestAdapter.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/20/24.
//

import Foundation
import Alamofire
import Auth

final class AuthApiRequestAdapter: RequestInterceptor {
  
  private let tokenManager: TokenManager = .shared
  
  init() {
  }
  
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    var urlRequest = urlRequest

    urlRequest.addValue(HTTPHeader.json.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)
    
//    if let languageCode = Locale.current.language.languageCode?.identifier {
//      urlRequest.headers.add(
//        name: HTTPHeader.acceptLanguage.rawValue,
//        value: languageCode
//      )
//    }
//    
    
    if let accessToken = tokenManager.getToken()?.accessToken {
      urlRequest.headers.add(
        name: HTTPHeader.authorization.rawValue,
        value: "\(HTTPHeader.bearer.rawValue) \(accessToken)"
      )
    }
            
    completion(.success(urlRequest))
  }
}
