//
//  FontAsset+UIFont.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/3/24.
//

#if canImport(UIKit)
import UIKit

public extension FontAsset {
  func toUIFont() -> UIFont {
    
    let asset = self
    
    if let bundle = asset.config.bundle {
      if let url = bundle.url(
        forResource: asset.config.fontName,
        withExtension: asset.config.fileType.rawValue
      ),
         let data = try? Data(contentsOf: url),
         let provider = CGDataProvider(data: data as CFData),
         let cgFont = CGFont(provider) {
        CTFontManagerRegisterGraphicsFont(cgFont, nil)
        return .init(name: asset.config.fontName, size: asset.size) ?? .init()
      }
    }
    return .init()
  }
}

public extension UIFont {
  static func asset(_ font: FontAsset) -> UIFont {
    font.toUIFont()
  }
}
#endif
