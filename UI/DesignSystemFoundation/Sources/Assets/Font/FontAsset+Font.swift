//
//  FontAsset+Font.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

#if canImport(SwiftUI)

import SwiftUI

public extension FontAsset {
  func toFont() -> Font {
    
    let asset = self
    
    if let bundle = asset.config.bundle {
      if let url = bundle.url(forResource: asset.config.fontName, withExtension: asset.config.fileType.rawValue),
         let provider = CGDataProvider(url: url as CFURL),
         let cgFont = CGFont(provider) {
        CTFontManagerRegisterGraphicsFont(cgFont, nil)
      }
    }
    
    return .custom(asset.config.fontName, size: asset.size, relativeTo: .body)
  }
}

public extension Font {
  static func asset(_ font: FontAsset) -> Font {
    font.toFont()
  }
}
#endif
