//
//  TargetType.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation
import Alamofire

public protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var header: [String: String] { get }
  var parameters: String? { get }
  var queryItems: Encodable? { get }
  var body: Data? { get }
  var sessionType: SessionType { get }
  var apiType: ApiType { get }
}

public enum ApiType {
  /// CookNow api 서버
  case CNApi
  /// CookNow auth 서버
  case CNAuth
}


public enum SessionType {
  case Auth
  case Api
  case AuthApi
}

public extension TargetType {
  var sessionType: SessionType { .Api }
  var apiType: ApiType { .CNApi }
}

extension TargetType {
  public func asURLRequest() throws -> URLRequest {
    
    guard let base = URL(string: baseURL) else {
      throw URLError(.badURL)
    }
    
    var components = URLComponents(url: base.appendingPathComponent(path), resolvingAgainstBaseURL: true)
    
    if let queryItems = try queryItems?.toDictionary() {
      components?.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
    }
    
    guard let url = components?.url else {
      throw URLError(.badURL)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = header
    
    if let params = parameters {
      urlRequest.httpBody = params.data(using: .utf8)
    } else {
      urlRequest.httpBody = body
    }
    
    return urlRequest
  }
}

extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
    return dictionary
  }
}
