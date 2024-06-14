//
//  ImageAsset+Constants.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/3/24.
//

import DesignSystemFoundation

public extension ImageAsset {
  static let onboardingBackground = ImageAsset("onboarding_bg", in: .module, format: .image)
  static let onboardingLogo = ImageAsset("onboarding_logo", in: .module, format: .image)
  static let appleLogin = ImageAsset("apple_login", in: .module, format: .image)
  static let googleLogin = ImageAsset("google_login", in: .module, format: .image)
  
  // MARK: Icon
  static let leftChevron = ImageAsset("left_chevron", in: .module, format: .image)
  static let rightChevron = ImageAsset("right_chevron", in: .module, format: .image)
  
  static let magnifyingglass = ImageAsset("magnifyingglass", in: .module, format: .image)
  static let xmark = ImageAsset("xmark", in: .module, format: .image)
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
