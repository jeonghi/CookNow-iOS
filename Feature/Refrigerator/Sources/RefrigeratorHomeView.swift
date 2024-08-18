//
//  RefrigeratorHomeView.swift
//  Refrigerator
//
//  Created by 쩡화니 on 8/16/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation

public struct RefrigeratorHomeView {
  public init() {
    
  }
  
  private enum Metric {
    static let refrigeratorBackgroundWidthRatio: CGFloat = 273/375
  }
}

extension RefrigeratorHomeView: View {
  public var body: some View {
    Color.clear
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        ZStack(alignment: .center) {
          Color.asset(.bgMain)
          backgroundView()
        } //: ZStack
          .ignoresSafeArea(.all)
      )
      .overlay(alignment: .top) {
        infoBoxView(.refrigeratorFilled)
          .padding(.top, 20)
          .padding(.horizontal, 20)
      }
  }
}

extension RefrigeratorHomeView {
  @ViewBuilder
  private func backgroundView() -> some View {
    GeometryReader { geo in
      let width = geo.size.width * Metric.refrigeratorBackgroundWidthRatio
      let centerX = geo.size.width / 2
      let centerY = geo.size.height / 2
      
      Image.asset(.refrigerator)
        .renderingMode(.original)
        .resizable()
        .scaledToFit()
        .frame(width: width)
        .position(x: centerX, y: centerY)
    }
  }
  
  @ViewBuilder
  private func infoBoxView(_ type: InfoBoxType) -> some View {
    CNInfomationBox(icon: type.icon, infoText: type.infoText, style: type.style)
  }
}

private extension RefrigeratorHomeView {
  enum InfoBoxType {
    case refrigeratorFilled
    case ingredientsManaged
    case expirationApproaching
    case expirationImminent
    
    var icon: ImageAsset {
      switch self {
      case .refrigeratorFilled:
        return .questionBox
      case .ingredientsManaged:
        return .sesac
      case .expirationApproaching:
        return .bomb
      case .expirationImminent:
        return .bomb
      }
    }
    
    var infoText: String {
      switch self {
      case .refrigeratorFilled:
        return "아래의 냉장고를 선택해 재료를 채워주세요!"
      case .ingredientsManaged:
        return "재료가 잘 관리되고 있어요!"
      case .expirationApproaching:
        return "슬슬 소비 마감 기한을 신경써주세요!"
      case .expirationImminent:
        return "소비 마감 기한이 다가오고 있어요!"
      }
    }
    
    var style: CNInfomationBox.Style {
      switch self {
      case .refrigeratorFilled, .ingredientsManaged:
        return .success
      case .expirationApproaching:
        return .warning
      case .expirationImminent:
        return .danger
      }
    }
  }
}


#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  RefrigeratorHomeView()
}
#endif
