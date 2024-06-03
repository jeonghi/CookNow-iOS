//
//  ColorAsset+UIColor.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

#if canImport(UIKit)
import UIKit

public extension ColorAsset {
  
  /// Convert to UIKit's UIColor
  func toUIColor() -> UIColor {
    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
  }
}

public extension UIColor {
  static func asset(_ color: ColorAsset) -> UIColor {
    return color.toUIColor()
  }
}

#endif
