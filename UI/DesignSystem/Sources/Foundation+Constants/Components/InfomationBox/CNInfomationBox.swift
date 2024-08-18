//
//  CNInfomationBox.swift
//  DesignSystem
//
//  Created by 쩡화니 on 8/16/24.
//

import SwiftUI
import DesignSystemFoundation

public struct CNInfomationBox {
  
  public typealias Style = InfoBoxStyle
  
  let icon: ImageAsset
  let description: String
  var style: Style
  
  public init(icon: ImageAsset, infoText: String, style: InfoBoxStyle = .default) {
    self.icon = icon
    self.description = infoText
    self.style = style
  }
  
  private enum Metric {
    static let horizontalPadding: CGFloat = 11
    static let verticalPadding: CGFloat = 7
    static let iconSize: CGFloat = 36
    static let horizontalSpacing: CGFloat = 3
    static let boxHeight: CGFloat = 48
    static let borderRadius: CGFloat = 6
    static let strokeLineWidth: CGFloat = 2
  }
}

extension CNInfomationBox: View {
  public var body: some View {
    HStack(spacing: Metric.horizontalSpacing) {
      iconView()
      descriptionView()
      Spacer()
    }
    .padding(.horizontal, Metric.horizontalPadding)
    .padding(.vertical, Metric.verticalPadding)
    .frame(maxWidth: .infinity)
    .frame(height: Metric.boxHeight)
    .background(
      RoundedRectangle(cornerRadius: 6, style: .continuous)
        .fill(style.backgroundColor.toColor())
        .overlay(
          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .stroke(style.strokeColor.toColor(), lineWidth: 2)
        )
    )
  }
}

extension CNInfomationBox {
  @ViewBuilder
  func iconView() -> some View {
    Image.asset(icon)
      .resizable()
      .renderingMode(.original)
      .scaledToFit()
      .frame(width: Metric.iconSize, height: Metric.iconSize)
  }
  
  @ViewBuilder
  func descriptionView() -> some View {
    Text(description)
      .foregroundStyle(style.tintColor.toColor())
      .lineLimit(1)
      .multilineTextAlignment(.leading)
      .font(.asset(.bodyBold2))
  }
}


public extension View where Self == CNInfomationBox {
  func infoboxStyle(_ style: InfoBoxStyle) -> CNInfomationBox {
    var copied = self
    copied.style = style
    return copied
  }
}


#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  CNInfomationBox(icon: .appleLogin, infoText: "아래의 냉장고를 선택해 재료를 채워주세요!")
    .infoboxStyle(.success)
    .padding()
}
#endif
