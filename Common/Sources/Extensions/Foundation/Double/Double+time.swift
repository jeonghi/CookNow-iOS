//
//  Double+time.swift
//  Common
//
//  Created by 쩡화니 on 8/15/24.
//

import Foundation

public extension Double {
  
  var hour: Double {
    self.minute * 60
  }
  
  var minute: Double {
    self * 60
  }
  
  var second: Double {
    self
  }
}
