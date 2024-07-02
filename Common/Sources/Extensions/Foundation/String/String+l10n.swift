//
//  String+l10n.swift
//  Common
//
//  Created by 쩡화니 on 7/2/24.
//

import Foundation

public extension String {
  
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  func localized(_ with: String) -> String {
    return String(format: self.localized, with)
  }
  
  func localized(_ number: Int) -> String {
    return String(format: self.localized, number)
  }
}
