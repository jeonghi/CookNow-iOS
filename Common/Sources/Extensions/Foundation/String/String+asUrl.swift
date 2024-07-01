//
//  String+asUrl.swift
//  Common
//
//  Created by 쩡화니 on 7/1/24.
//

import Foundation

public extension String {
  func asUrl() -> URL? {
    URL(string: self)
  }
}
