//
//  InfoBoxStyle.swift
//  DesignSystem
//
//  Created by 쩡화니 on 8/16/24.
//

import DesignSystemFoundation

public struct InfoBoxStyle {
  let tintColor: ColorAsset
  let backgroundColor: ColorAsset
  let strokeColor: ColorAsset
}

public extension InfoBoxStyle {
  static let `default` = InfoBoxStyle(tintColor: .white, backgroundColor: .success500, strokeColor: .success300)
  static let success = InfoBoxStyle.default
  static let warning = InfoBoxStyle(tintColor: .white, backgroundColor: .warning500, strokeColor: .warning300)
  static let danger = InfoBoxStyle(tintColor: .white, backgroundColor: .danger500, strokeColor: .danger300)
}
