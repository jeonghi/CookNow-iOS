//
//  AFLogger.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation
import Alamofire
import Common

/// 네트워크 통신 디버깅용
public final class AFLogger: EventMonitor {
  
  public static let shared = AFLogger()
  
  private init() {}
  
  public func requestDidResume(_ request: Request) {
    
    let headersString = request.request?.headers.dictionary.jsonData?.toPrettyPrintedString ?? ""
    let bodyString = request.request?.httpBody?.toPrettyPrintedString ?? ""
    
    let message = """
      \n⬆️ Request Started: \(request)
      Header: \(headersString)
      Body: \(bodyString)
    """
    CNLog.i(message)
  }
  
  public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    
    
    let statusCode = (response.response?.statusCode ?? 0)
    let statusIcon = (200 ..< 300 ~= statusCode) ? "✅" : "⛔️"
    
    let message = """
      \n⬇️ Response Done: \(request.request?.url?.absoluteString ?? "")
      StatusCode: \(statusIcon) \(statusCode)
      Body: \(response.data?.toPrettyPrintedString ?? "")
    """
    
    CNLog.i(message)
  }
}

extension Data {
  var toPrettyPrintedString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    return prettyPrintedString as String
  }
}

extension Dictionary where Key: Encodable, Value: Encodable {
  var jsonData: Data? {
    try? JSONSerialization.data(withJSONObject: self, options: [])
  }
}
