//
//  ApiRequestAdapter.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation
import Alamofire

final class ApiRequestAdapter: RequestInterceptor {
  
  init() {
  }
  
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    var urlRequest = urlRequest
    
    // TODO: 기본 Api 요청할 때 필요한 기능 추가 (예: API서버 인증 키 헤더에 추가 등..)
    
    completion(.success(urlRequest))
  }
}
