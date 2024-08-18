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
  
  // MARK: Tab Icon
  static let refrigeratorTab = ImageAsset("refrigeratorTab", in: .module, format: .image) // 냉장고
  static let refrigeratorSelectedTab = ImageAsset("refrigeratorSelectedTab", in: .module, format: .image) // 냉장고 (선택)
  static let ingredientBoxTab = ImageAsset("ingredientBoxTab", in: .module, format: .image) // 재료함
  static let ingredientBoxSelectedTab = ImageAsset("ingredientBoxSelectedTab", in: .module, format: .image) // 재료함 (선택)
  static let settingTab = ImageAsset("settingTab", in: .module, format: .image) // 설정
  static let settingSelectedTab = ImageAsset("settingSelectedTab", in: .module, format: .image) // 설정 (선택)
  
  
  // MARK: Icon
  static let leftChevron = ImageAsset("left_chevron", in: .module, format: .image)
  static let rightChevron = ImageAsset("right_chevron", in: .module, format: .image)
  
  static let magnifyingglass = ImageAsset("magnifyingglass", in: .module, format: .image)
  static let xmark = ImageAsset("xmark", in: .module, format: .image)
  
  // MARK: Refrigerator
  static let refrigerator = ImageAsset("refrigerator", in: .module, format: .image)
  
  // MARK: IngredientBox
  static let ingredientBoxHomeHeaderBackground = ImageAsset("ingredient_box_home_header", in: .module, format: .image)
  
  // MARK: InformationBox
  static let sesac = ImageAsset("sesac", in: .module, format: .image)
  static let questionBox = ImageAsset("questionBox", in: .module, format: .image)
  static let bomb = ImageAsset("bomb", in: .module, format: .image)
  static let bigEye = ImageAsset("bigEye", in: .module, format: .image)
}
