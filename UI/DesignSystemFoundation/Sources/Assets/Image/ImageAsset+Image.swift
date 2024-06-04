//
//  ImageAsset+Image.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/4/24.
//

#if canImport(SwiftUI)

import SwiftUI

public extension ImageAsset {
  func toImage() -> Image {
    if let uiImage = format.convert(self) as? UIImage {
      return Image(uiImage: uiImage)
    }
    
    fatalError("Failed to convert ImageAsset to SwiftUI Image")
  }
}

public extension Image {
  static func asset(_ asset: ImageAsset) -> Image {
    asset.toImage()
  }
}

#endif
