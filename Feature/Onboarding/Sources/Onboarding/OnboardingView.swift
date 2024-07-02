//
//  OnboardingView.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import Common

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
    Image.asset(.onboardingBackground)
      .resizable()
      .renderingMode(.original)
      .aspectRatio(contentMode: .fill)
      .background(
        Color.asset(.bgMain)
      )
  }
  
  /// 로고
  private var logo: some View {
    Image.asset(.onboardingLogo)
      .resizable()
      .renderingMode(.original)
      .aspectRatio(contentMode: .fit)
      .frame(width: 192)
  }
  
  /// 타이틀
  private var title: some View {
    Text("app_name", bundle: .module)
      .font(
        FontAsset(.bold, size: 39, leading: .custom(47)).toFont()
      )
    
      .foregroundStyle(Color.asset(.black))
  }
  
  private var socialSignUpLabel: some View {
    Text("signup_with_social", bundle: .module)
      .font(
        FontAsset(.regular, size: 14, leading: .custom(17)).toFont()
      )
      .foregroundStyle(Color.asset(.black))
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
        return .asset(.appleLogin)
      case.google:
        return .asset(.googleLogin)
      }
    }
    
    var closure: (() -> Void)? {
      return nil
    }
  }
}

#Preview {
  print("signup_with_social".localized)
  return OnboardingView()
    .environment(\.locale, .init(identifier: "en"))
}
