//
//  ColorAsset.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import SwiftUI
import UIKit

public struct ColorAsset {
  
  enum ColorType {
    case literal
    case asset(named: String, bundler: Bundle?)
  }
  
  var red: Double
  var green: Double
  var blue: Double
  var alpha: Double
  var colorType: ColorType
  
  public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.colorType = .literal
  }
  
  public init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    
    Scanner(string: hex).scanHexInt64(&int)
    
    let r = Double((int >> 16) & 0xFF) / 255.0
    let g = Double((int >> 8) & 0xFF) / 255.0
    let b = Double(int & 0xFF) / 255.0
    
    self.init(red: r, green: g, blue: b, alpha: 1.0)
  }
  
  public init(named: String, bundle: Bundle? = nil, alpha: Double = 1.0) {
    let color = UIColor(named: named, in: bundle, compatibleWith: nil)
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    color?.getRed(&red, green: &green, blue: &blue, alpha: nil)
    
    self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: alpha)
  }

  public func with(alpha: Double) -> ColorAsset {
    return ColorAsset(red: self.red, green: self.green, blue: self.blue, alpha: alpha)
  }
}

