//
//  AppConfigurationValue.swift
//  Common
//
//  Created by 쩡화니 on 7/23/24.
//

import Foundation

@propertyWrapper
public struct AppConfigurationValue {
  
  private var key: String
  
  public init(_ key: String) {
    self.key = key
  }
  
  public lazy var wrappedValue: String = loadValueForKey(self.key)
  
  private func loadValueForKey(_ key: String, bundle: Bundle = .main) -> String {
    guard let value = bundle.object(forInfoDictionaryKey: key) as? String else {
      fatalError("\(key) must not be empty in plist")
    }
    CNLog.d("\n🔐[\(key)] : [\(value)]")
    return value
  }
}
