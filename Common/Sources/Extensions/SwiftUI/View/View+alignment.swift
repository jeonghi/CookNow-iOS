//
//  View+alignment.swift
//  Common
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI

public extension View {
  /// 수평 정렬: leading
  func hLeading() -> some View {
    self.frame(maxWidth: .infinity, alignment: .leading)
  }
  
  /// 수평 정렬: trailing
  func hTrailing() -> some View {
    self.frame(maxWidth: .infinity, alignment: .trailing)
  }
  
  /// 수평 정렬: center
  func hCenter() -> some View {
    self.frame(maxWidth: .infinity, alignment: .center)
  }
  
  /// 수직 정렬: top
  func vTop() -> some View {
    self.frame(maxHeight: .infinity, alignment: .top)
  }
  
  /// 수직 정렬: bottom
  func vBottom() -> some View {
    self.frame(maxHeight: .infinity, alignment: .bottom)
  }
  
  /// 수직 정렬: center
  func vCenter() -> some View {
    self.frame(maxHeight: .infinity, alignment: .center)
  }
}
