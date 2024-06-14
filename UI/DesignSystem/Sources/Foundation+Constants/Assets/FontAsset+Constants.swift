//
//  FontAsset+Constants.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/3/24.
//

import DesignSystemFoundation

enum FontFamily: String {
  case Pretendard
}

public extension FontAsset.FontConfig {
  static var bold: FontAsset.FontConfig = .init(
    fontFamily: FontFamily.Pretendard.rawValue,
    weight: .bold,
    bundle: .module,
    fileType: .otf
  )
  static var regular: FontAsset.FontConfig = .init(
    fontFamily: FontFamily.Pretendard.rawValue,
    weight: .regular,
    bundle: .module,
    fileType: .otf
  )
  
  static var semibold: FontAsset.FontConfig = .init(
    fontFamily: FontFamily.Pretendard.rawValue,
    weight: .semiBold,
    bundle: .module,
    fileType: .otf
  )
}

public extension FontAsset.Leading {
  
}

public extension FontAsset {
  
  // title
  static var logoTitle: FontAsset = .init(.bold, size: 38)
  
  // headline
  static var headline1: FontAsset = .init(.bold, size: 20)
  
  // subheadline
  static var subhead3: FontAsset = .init(.bold, size: 16)
  static var subhead2: FontAsset = .init(.bold, size: 14)
  static var subhead1: FontAsset = .init(.bold, size: 12)
  
  // body
  static var body3: FontAsset = .init(.regular, size: 16)
  static var bodyBold3: FontAsset = .init(.bold, size: 16)
  
  static var body2: FontAsset = .init(.regular, size: 14)
  static var bodyBold2: FontAsset = .init(.bold, size: 14)
  
  static var body1: FontAsset = .init(.regular, size: 12)
  static var bodyBold1: FontAsset = .init(.bold, size: 12)
  
  static var caption: FontAsset = .init(.regular, size: 12)
  
  // Legacy
  static var title1: FontAsset = .init(.bold, size: 22)
  static var title2: FontAsset = .init(.bold, size: 14)
  static var bodyBold: FontAsset = .init(.bold, size: 13)
  static var body: FontAsset = .init(.regular, size: 13)
}

#if canImport(SwiftUI)
import SwiftUI

#Preview {
  ScrollView {
    Text("테스트1")
      .font(Font.asset(.title1))
  }
}

#endif
