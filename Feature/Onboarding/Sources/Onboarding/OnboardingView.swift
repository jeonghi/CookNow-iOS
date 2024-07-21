//
//  OnboardingView.swift
//  ProjectDescriptionHelpers
//
//  Created by 쩡화니 on 6/2/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import ComposableArchitecture
import Common
import Lottie

// MARK: Properties
public struct OnboardingView: BaseFeatureViewType {
  
  public typealias Core = OnboadingCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    var isAnimating: Bool
    public init(state: CoreState) {
      isAnimating = state.isAnimating
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: OnboadingCore.State()
    ){
      OnboadingCore()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
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
  
  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        logo
        title
          .padding(.top, Metric.titleTopPadding)
        socialSignUpLabel
          .padding(.top, Metric.socialSignUpLabelTopPadding)
        HStack(spacing: Metric.socialSignUpButtonStackHorizontalSpacing) {
          socialSignUpButtonStack
        } // HStack
        .padding(.top, Metric.socialSignUpButtonStackTopPadding)
      } // VStack
      .opacity(viewStore.isAnimating ? 0 : 1)
      .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/(duration: 0.5), value: !viewStore.isAnimating)
    } // ZStack
    .frameAllInfinity()
    .onLoad {
      viewStore.send(.isAnimating(true))
    }
    .onAppear {
      
    }
    .background(
      ZStack {
        Color.asset(.bgMain)
        lottieBackground
      }
    )
    .ignoresSafeArea()
  }
}

// MARK: Component
extension OnboardingView {
  
  /// 로티 애니메이션
  private var lottieBackground: some View {
    LottieView(
      animation: LottieAnimation.named(
        "initial_app_screen",
        bundle: .module
      )
    )
    .animationSpeed(0.2)
    .playing()
    .animationDidFinish({ completed in
      viewStore.send(.isAnimating(false))
    })
    .resizable()
    .ignoresSafeArea(.all)
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
    Button(action: {viewStore.send(type.action)}) {
      type.iconImage
      
    }.buttonStyle(SocialLoginButtonStyle())
  }
  
  struct SocialLoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .aspectRatio(contentMode: .fit)
        .frame(width: 54, height: 54)
    }
  }
  
  private enum SocialLoginType: CaseIterable {
    case apple
    case google
    
    private var _iconImage: Image {
      switch self {
      case .apple:
        return .asset(.appleLogin)
        
      case.google:
        return .asset(.googleLogin)
      }
    }
    
    var iconImage: Image {
      _iconImage
        .resizable()
        .renderingMode(.original)
    }
    
    var action: OnboadingCore.Action {
      switch self {
      case .apple:
        return .appleSignInButtonTapped
      case .google:
        return .googleSignInButtonTapped
      }
    }
  }
}

#Preview {
  return OnboardingView()
}
