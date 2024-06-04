//
//  ImageAsset+UIImage.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/4/24.
//

#if canImport(UIKit)

import UIKit

public extension ImageAsset {
  func toUIImage() -> UIImage {
    if let uiImage = format.convert(self) as? UIImage {
      return uiImage
    }
    fatalError("Failed to convert ImageAsset to UIImage")
  }
}

public extension UIImage {
  static func asset(_ asset: ImageAsset) -> UIImage {
    return asset.toUIImage()
  }
}

#endif
