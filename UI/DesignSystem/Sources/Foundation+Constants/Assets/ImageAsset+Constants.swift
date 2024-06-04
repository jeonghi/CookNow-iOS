//
//  ImageAsset+Constants.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/3/24.
//

import DesignSystemFoundation

public extension ImageAsset {
  
}

#if(DEBUG) && canImport(SwiftUI)
import SwiftUI

private extension ImageAsset {
  static let sampleImage = ImageAsset("sample_image", in: .module, format: .image)
}

#Preview {
  Image.asset(.sampleImage)
}

#endif
