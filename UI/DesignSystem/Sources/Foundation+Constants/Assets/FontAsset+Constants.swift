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
  static var title1: FontAsset = .init(.bold, size: 22)
  static var title2: FontAsset = .init(.bold, size: 14)
  static var bodyBold: FontAsset = .init(.bold, size: 13)
  static var body: FontAsset = .init(.regular, size: 13)
  static var caption: FontAsset = .init(.regular, size: 12)
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
