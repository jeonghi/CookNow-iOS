//
//  Array+safe.swift
//  Common
//
//  Created by 쩡화니 on 7/27/24.
//

import Foundation

public extension Array {
  subscript (safe index: Array.Index) -> Element? {
    get {
      return indices ~= index ? self[index] : nil
    }
    set {
      guard let element = newValue else { return }
      self[index] = element
    }
  }
}
