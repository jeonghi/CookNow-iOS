//
//  ColorAsset+Color.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

#if canImport(SwiftUI)
import SwiftUI

public extension ColorAsset {
  /// Convert to SwiftUI's Color
  func toColor() -> Color {
    return Color(red: red, green: green, blue: blue, opacity: alpha)
  }
}

public extension Color {
  static func asset(_ color: ColorAsset) -> Color {
    color.toColor()
  }
}
#endif
