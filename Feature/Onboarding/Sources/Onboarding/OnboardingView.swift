//
//  OnboardingView.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import SwiftUI
import DesignSystem

// MARK: Properties
struct OnboardingView {
  
  @StateObject var viewModel: OnboardingViewModel
  
  init(viewModel: OnboardingViewModel = .init()) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
}

// MARK: Layout
extension OnboardingView: View {
  var body: some View {
    ZStack {
      logo
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      background
    )
  }
}

// MARK: Component
extension OnboardingView {
  
  /// 배경
  private var background: some View {
    Image(.onboardingBg)
      .resizable()
      .renderingMode(.original)
      .aspectRatio(contentMode: .fill)
      .background(
        Color(asset: DesignSystemAsset.bg300)
      )
  }
  
  /// 로고
  private var logo: some View {
    Image(.onboardingLogo)
      .resizable()
      .renderingMode(.original)
      .aspectRatio(contentMode: .fit)
      .frame(width: 192)
  }
}

#Preview {
  OnboardingView()
}
