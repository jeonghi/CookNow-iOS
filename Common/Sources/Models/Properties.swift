//
//  Properties.swift
//  Common
//
//  Created by 쩡화니 on 7/21/24.
//

import Foundation

public final class Properties {
  
  public static func saveCodable<T: Codable>(key: String, data: T?) {
    if let encoded = try? JSONEncoder().encode(data) {
      UserDefaults.standard.set(encoded, forKey: key)
      UserDefaults.standard.synchronize()
    }
  }
  
  public static func loadCodable<T: Codable>(key: String) -> T? {
    if let data = UserDefaults.standard.data(forKey: key) {
      return try? JSONDecoder().decode(T.self, from: data)
    }
    return nil
  }
  
  public static func delete(_ key: String) {
    UserDefaults.standard.removeObject(forKey: key)
  }
  
  static func save(key: String, string: String?) {
    UserDefaults.standard.set(string, forKey: key)
    UserDefaults.standard.synchronize()
  }
  
  static func load(key: String) -> String? {
    UserDefaults.standard.string(forKey: key)
  }
}
