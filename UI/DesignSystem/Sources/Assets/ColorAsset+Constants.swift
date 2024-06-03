//
//  ColorAsset+Constants.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/2/24.
//

import DesignSystemFoundation


public extension ColorAsset {
  static let bg100 = ColorAsset(named: "bg100", bundle: .module)
  static let bg200 = ColorAsset(named: "bg200", bundle: .module)
  static let bgMain = ColorAsset(named: "bg300", bundle: .module)
}

#if canImport(SwiftUI)
import SwiftUI
#Preview {
  ScrollView {
    ColorAsset.bg100.toColor()
    ColorAsset.bg200.toColor()
    ColorAsset.bgMain.toColor()
  }
}
#endif
