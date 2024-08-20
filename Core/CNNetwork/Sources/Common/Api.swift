//
//  Api.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Common
import Foundation
import Alamofire

let API = Api.shared


final class Api {
  static let shared = Api()
  
  let encoding: URLEncoding
  
  /// 세션들 한번에 관리
  var sessions: [SessionType: Session] = [SessionType:Session]()
  
  init() {
    self.encoding = URLEncoding(boolEncoding: .literal)
    initSession()
  }
}

extension Api {
  
  private func initSession() {
    
    let apiSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
    
    var eventMonitors: [EventMonitor] = []
    
    #if(DEBUG)
    eventMonitors.append(AFLogger.shared)
    #endif
    
    addSession(type: .Api, session: Session(configuration: apiSessionConfiguration, interceptor: ApiRequestAdapter(), eventMonitors: eventMonitors))
    
    let authSessionConfiguration : URLSessionConfiguration = URLSessionConfiguration.default
    addSession(type: .Auth, session: Session(configuration: authSessionConfiguration, interceptor: ApiRequestAdapter(), eventMonitors: eventMonitors))
  }
  
  func addSession(type: SessionType, session: Session) {
    if self.sessions[type] == nil {
      self.sessions[type] = session
    }
  }
  
  func session(_ sessionType: SessionType) -> Session {
    return sessions[sessionType] ?? sessions[.Api]!
  }
}

extension Api {
  
  func getCommonError(error: Error) -> CNNetworkError? {
    if let afError = error as? AFError {
      switch afError {
      case .responseValidationFailed(let reason):
        switch reason {
        case .customValidationFailed(let error):
          return error as? CNNetworkError
        default:
          break
        }
      case .requestAdaptationFailed(let error):
        return error as? CNNetworkError
      default:
        break
      }
    }
    return nil
  }
  
  func getRequestRetryFailedError(error:Error) -> CNNetworkError? {
    if let afError = error as? AFError {
      switch afError {
      case .requestRetryFailed(let retryError, _):
        return retryError as? CNNetworkError
      default:
        break
      }
    }
    return nil
  }
  
  func responseData(_ HTTPMethod: Alamofire.HTTPMethod,
                    _ url: String,
                    parameters: [String: Any]? = nil,
                    headers: [String: String]? = nil,
                    sessionType: SessionType = .AuthApi,
                    apiType: ApiType,
                    logging: Bool = true,
                    completion: @escaping (HTTPURLResponse?, Data?, Error?) -> Void) {
    
    API.session(sessionType)
      .request(
        url,
        method: HTTPMethod,
        parameters: parameters,
        encoding: API.encoding,
        headers: (headers != nil ? HTTPHeaders(headers!): nil)
      )
      .validate { request, response, data in
        if let data {
          var json: Any? = nil
          do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
          } catch {
            CNLog.e(error)
          }
          
          CNLog.d("===================================================================================================")
          CNLog.d("session: \n type: \(sessionType)\n\n")
          CNLog.i("request: \n method: \(HTTPMethod)\n url:\(url)\n headers:\(String(describing: headers))\n parameters: \(String(describing: parameters)) \n\n")
          (logging) ? CNLog.i("response:\n \(String(describing: json))\n\n" ) : CNLog.i("response: - \n\n")
          
          if let commonError = CNNetworkError(response: response, data: data, type: apiType) {
            return .failure(commonError)
          }
          
          else {
            return .success(Void())
          }
        }
        else {
          return .failure(CNNetworkError(reason: .Unknown, message: "data is nil."))
        }
      }
      .responseData { [unowned self] response in
        if let afError = response.error, let retryError = self.getRequestRetryFailedError(error: afError) {
          CNLog.e("response:\n api error: \(retryError)")
          completion(nil, nil, retryError)
        }
        else if let afError = response.error, self.getCommonError(error: afError) == nil {
          //일반에러
          CNLog.e("response:\n not api error: \(afError)")
          completion(nil, nil, afError)
        }
        else if let data = response.data, let response = response.response {
          if let commonError = CNNetworkError(response: response, data: data, type: apiType) {
            completion(nil, nil, commonError)
            return
          }
          
          completion(response, data, nil) // ⭐️ 정상적인 응답
        }
        else {
          //data or response 가 문제
          CNLog.e("response:\n error: response or data is nil.")
          completion(nil, nil, CNNetworkError(reason: .Unknown, message: "response or data is nil."))
        }
      }
  }
}

