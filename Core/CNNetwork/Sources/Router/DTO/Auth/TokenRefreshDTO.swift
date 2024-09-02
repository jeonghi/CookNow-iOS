//
//  TokenRefreshDTO.swift
//  CNNetwork
//
//  Created by 쩡화니 on 8/30/24.
//

import Foundation

enum TokenRefreshDTO {
  struct Response: Decodable {
    let accessToken: String
  }
}
