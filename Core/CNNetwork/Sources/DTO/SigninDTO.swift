//
//  SigninDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

public enum SignInDTO {
  public struct Request: Encodable {
    let idToken: String
    
    public init(_ idToken: String) {
      self.idToken = idToken
    }
  }
  
  public struct Response: Decodable {
    public let accessToken: String
    public let refreshToken: String
  }
}
