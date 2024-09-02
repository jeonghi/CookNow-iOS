//
//  RefrigeratorHomeView.swift
//  Refrigerator
//
//  Created by 쩡화니 on 8/16/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import Domain
import Common
import ComposableArchitecture

// MARK: Properties
public struct RefrigeratorHomeView: BaseFeatureViewType {
  
  public typealias Core = RefrigeratorHomeCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  @State private var selectedTab: Int?
  @State private var isShaking: Bool = false
  @State private var timer: Timer? // 타이머를 저장할 상태 변수 추가

  
  public struct ViewState: Equatable {
    
    var categories: [IngredientCategory]
    var ingredients: [Ingredient]
    var storageType: [IngredientStorage] = [
      IngredientStorage.dummyData,
      IngredientStorage.dummyData,
      IngredientStorage.dummyData
    ]
    
    public init(state: CoreState) {
      categories = state.categories
      ingredients = state.ingredients
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State()
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
  
  private enum Metric {
    static let refrigeratorBackgroundWidthRatio: CGFloat = 273/375
    static let rotatation: CGFloat = 1
    static let animationTimeInterval: CGFloat = 0.3
  }
}


extension RefrigeratorHomeView: View {
  public var body: some View {
    VStack {
      infoBoxView(.refrigeratorFilled)
        .padding(.top, 20)
        .padding(.horizontal, 20)
      
      if let selectedTab {
        
      } else {
        backgroundView()
      }
    }
    .ignoresSafeArea(edges: [.horizontal])
    .onAppear {
      timer = Timer.scheduledTimer(withTimeInterval: Metric.animationTimeInterval, repeats: true) { _ in
        Task { @MainActor in
          withAnimation {
            isShaking.toggle()
          }
        }
      }
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
    .background(
      ZStack(alignment: .center) {
        Color.asset(.bgMain)
      } //: ZStack
    )
    .overlay(alignment: .top) {
      
    }
    .kerning(-0.6) // 자간 -0.6
  }
}

extension RefrigeratorHomeView {
  @ViewBuilder
  private func backgroundView() -> some View {
    GeometryReader { geo in
      let width = geo.size.width * Metric.refrigeratorBackgroundWidthRatio
      let centerX = geo.size.width / 2
      let centerY = geo.size.height / 2
      
      Button(action: { viewStore.send(.refrigeratorTapped) }) {
        Image.asset(.refrigerator)
          .renderingMode(.original)
          .resizable()
          .scaledToFit()
          .frame(width: width)
          .position(x: centerX, y: centerY)
          .rotationEffect(isShaking ? .degrees(-Metric.rotatation) : .degrees(Metric.rotatation))
          .animation(
            Animation.easeInOut(duration: Metric.animationTimeInterval)
              .repeatForever(autoreverses: true),
            value: true
          )
      }
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
