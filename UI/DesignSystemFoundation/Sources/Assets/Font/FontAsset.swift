//
//  FontAsset.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

import Foundation

public struct FontAsset {
  
  /// FontFamily / Weight / Bundle / 확장자 (ex. otf, ttf...) 등
  var config: FontConfig
  /// 크기
  var size: CGFloat
  /// 행간
  var leading: FontAsset.Leading?
  
  var lineHeight: CGFloat {
    size + (leading?.value ?? 0)
  }
  
  public init(
    _ config: FontConfig,
    size: CGFloat,
    leading: FontAsset.Leading? = nil
  ) {
    self.config = config
    self.size = size
    self.leading = leading
  }
}

// MARK: FontLeading
public extension FontAsset {
  enum Leading {
    case none
    case small
    case medium
    case large
    case custom(CGFloat)
    
    var value: CGFloat {
      switch self {
      case .none:
        return 0
      case .small:
        return 5.0
      case .medium:
        return 10.0
      case .large:
        return 15.0
      case .custom(let value):
        return value
      }
    }
  }
}

// MARK: FontConfig
public extension FontAsset {
  struct FontConfig {
    
    public enum Weight: String {
      case black
      case bold
      case extraBold
      case extraLight
      case light
      case medium
      case regular
      case semiBold
      case thin
    }
    
    public enum FileType: String {
      case otf
      case ttf
    }
    
    public var fontFamily: String
    public var weight: Weight
    public var bundle: Bundle?
    public var fileType: FileType
    
    public init(fontFamily: String, weight: Weight, bundle: Bundle? = nil, fileType: FileType) {
      self.fontFamily = fontFamily
      self.weight = weight
      self.bundle = bundle
      self.fileType = fileType
    }
    
    var fontName: String {
      return "\(fontFamily)-\(weight.rawValue.capitalized)"
    }
    
    var fontPath: String {
      return "\(fontName).\(fileType.rawValue)"
    }
  }
}
