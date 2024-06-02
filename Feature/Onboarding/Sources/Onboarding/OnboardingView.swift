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

// MARK: Constants
extension OnboardingView {
  private enum Metric {
    static var titleTopPadding: CGFloat { 18 }
    static var socialSignUpLabelTopPadding: CGFloat { 44 }
    static var socialSignUpButtonStackHorizontalSpacing: CGFloat { 10 }
    static var socialSignUpButtonStackTopPadding: CGFloat { 20 }
  }
}

// MARK: Layout
extension OnboardingView: View {
  
  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        logo
        title
          .padding(.top, Metric.titleTopPadding)
        socialSignUpLabel
          .padding(.top, Metric.socialSignUpLabelTopPadding)
        HStack(spacing: Metric.socialSignUpButtonStackHorizontalSpacing) {
          socialSignUpButtonStack
        }
        .padding(.top, Metric.socialSignUpButtonStackTopPadding)
      }
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
  
  /// 타이틀
  private var title: some View {
    Text("쿡 나우")
      .font(
        DesignSystemFontFamily
          .Pretendard
          .bold
          .swiftUIFont(size: 39)
      )
  }
  
  private var socialSignUpLabel: some View {
    Text("소셜 계정으로 간편 가입하기")
      .font(
        DesignSystemFontFamily
          .Pretendard
          .medium
          .swiftUIFont(size: 14)
      )
  }
  
  private var socialSignUpButtonStack: some View {
    ForEach(SocialLoginType.allCases, id: \.self) {
      makeSocialLoginButton(type: $0)
    }
  }
  
  @ViewBuilder
  private func makeSocialLoginButton(
    type: SocialLoginType
  ) -> some View {
    Button(action: {type.closure?()}) {
      type.iconImage
        .resizable()
        .renderingMode(.original)
        .aspectRatio(contentMode: .fit)
        .frame(width: 54, height: 54)
    }
  }
  
  private enum SocialLoginType: CaseIterable {
    case apple
    case google
    
    var iconImage: Image {
      switch self {
      case .apple:
        return Image(.appleLogin)
      case.google:
        return Image(.googleLogin)
      }
    }
    
    var closure: (() -> Void)? {
      return nil
    }
  }
}

#Preview {
  OnboardingView()
}
