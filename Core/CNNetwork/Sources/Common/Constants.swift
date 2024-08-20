//
//  Constants.swift
//  CNNetwork
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation
import Common

final class Constants {
  @AppConfigurationValue("API_SERVER_BASE_URL") static var baseUrl
  @AppConfigurationValue("AUTH_SERVER_BASE_URL") static var authBaseUrl
}
