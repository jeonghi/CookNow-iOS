//
//  IngredientInputFormView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/24/24.
//

import SwiftUI
import ComposableArchitecture
import Common
import DesignSystem
import DesignSystemFoundation
import Domain


// MARK: Properties
public struct IngredientInputFormView: BaseFeatureViewType {
  
  typealias FormCard = IngredientInputFormCardCore
  public typealias Core = IngredientInputFormCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  @Environment(\.dismiss) private var dismiss
  
  public struct ViewState: Equatable {
    
    var ingredientStorageList: [IngredientStorage]
    var isLoading: Bool
    var isDismiss: Bool
    
    // MARK: 계산 프로퍼티
    var doneButtonEnable: Bool { ingredientStorageList.count > 0 && !isLoading }
    var isIngredientEmpty: Bool { ingredientStorageList.count <= 0 }
    
    
    public init(state: CoreState) {
      ingredientStorageList = state.ingredientStorageList
      isLoading = state.isLoading
      isDismiss = state.isDismiss
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
}

private extension IngredientInputFormView {
  enum Metric {
    static var contentHorizontalPadding: CGFloat = 20
    static var contentVerticalPadding: CGFloat = 20
    static var doneButtonBottomPadding: CGFloat = 30
    
    static var infoLabelAndAdBannerSpacing: CGFloat = 18
    static var notiLabelSpacing: CGFloat = 2
    static var notiLabelAndButtonSpacing: CGFloat = 20
  }
}

private extension ButtonSize {
  static let addIngredient = ButtonSize(width: 114, height: 40)
}

// MARK: Layout
extension IngredientInputFormView: View {
  
  public var body: some View {
    
    if viewStore.isDismiss {
      dismiss()
    }
    
    return VStack {
      VStack(spacing: Metric.infoLabelAndAdBannerSpacing) {
        introductionSection()
//        adSection()
      }
      .padding(.horizontal, Metric.contentHorizontalPadding)
      .padding(.top, 10)
      
      ScrollView(.vertical) {
        Group {
          ingredientStorageFormListSection()
            .padding(.vertical, Metric.contentVerticalPadding)
        }
        .padding(.horizontal, Metric.contentHorizontalPadding)
        Divider()
        
        Group {
          addIngredientSection()
            .padding(.vertical, Metric.contentVerticalPadding)
        }
        .padding(.horizontal, Metric.contentHorizontalPadding)
        
        Divider()
      }
      .replaceIf(viewStore.isIngredientEmpty) {
        noIngredientSection()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      
      formInputDoneButton()
        .padding(.horizontal, Metric.contentHorizontalPadding)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .kerning(-0.6)
    .safeAreaBottomPadding(defaultPadding: Metric.doneButtonBottomPadding, safeAreaPadding: Metric.doneButtonBottomPadding)
    .cnLoading(viewStore.isLoading)
    .onAppear {
      viewStore.send(.onAppear)
    }
    .onDisappear {
      viewStore.send(.onDisappear)
    }
  }
}

// MARK: Components
private extension IngredientInputFormView {
  
  // MARK: Section
  @ViewBuilder
  func introductionSection() -> some View {
    introductionLabel()
      .hLeading()
  }
  
  @ViewBuilder
  func adSection() -> some View {
    adArea()
      .hCenter()
  }
  
  @ViewBuilder
  func ingredientStorageFormListSection() -> some View {
    IngredientInputFormCardListView(ingredientInputFormCardListStore)
  }
  
  @ViewBuilder
  func addIngredientSection() -> some View {
    HStack {
      addIngredientSectionLabel()
      addIngredientSectionButton()
    }
  }
  
  @ViewBuilder
  func noIngredientSection() -> some View {
    VStack(alignment: .center, spacing: Metric.notiLabelAndButtonSpacing) {
      notificationLabel()
      addIngredientSectionButton()
    }
  }
  
  // MARK: Other Components
  
  @ViewBuilder
  func notificationLabel() -> some View {
    VStack(alignment: .center, spacing: Metric.notiLabelSpacing) {
      Text("정보를 입력할 재료가 없습니다.")
        .font(.asset(.subhead2))
      Text("아래 재료 추가하기 버튼으로\n재료를 추가해서 정보를 입력해보세요!")
        .font(.asset(.caption))
    }
    .multilineTextAlignment(.center)
  }
  
  @ViewBuilder
  func introductionLabel() -> some View {
    Text("내 냉장고에 있는 재료들을 선택하고 정보를 입력해보세요!")
      .multilineTextAlignment(.leading)
      .lineLimit(2)
      .font(.asset(.caption))
      .foregroundStyle(Color.asset(.gray800))
  }
  
  @ViewBuilder
  func adArea() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 6)
        .fill(Color.asset(.danger300))
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.asset(.gray400))
        )
      Text("광고 영역")
    }
    .aspectRatio(335/60, contentMode: .fit)
    .frame(maxWidth: .infinity)
  }
  
  @ViewBuilder
  func addIngredientSectionButton() -> some View {
    Button(action: { viewStore.send(.addIngredientButtonTapped) }) {
      Label("재료 추가하기", systemImage: "plus")
    }
    .buttonStyle(StateButtonStyle.secondary(.addIngredient))
  }
  
  @ViewBuilder
  func addIngredientSectionLabel() -> some View {
    Group {
      Text("더 필요한게 있나요?\n").font(.asset(.subhead2)) +
      Text("빠진 재료가 있다면 추가해보세요").font(.asset(.caption))
    }
    .lineSpacing(5)
    .hLeading()
  }
  
  @ViewBuilder
  func formInputDoneButton() -> some View {
    Button(action: {
      viewStore.send(.doneButtonTapped)
    }) {
      Text("입력 완료")
    }
    .buttonStyle(StateButtonStyle.primary(.done))
    .disabled(!viewStore.doneButtonEnable)
  }
  
  // MARK: Popup
  @ViewBuilder
  func askForRemovePopup() -> some View {
    VStack(alignment: .center, spacing: 16) {
      Text("삭제")
        .font(.asset(.headline1))
        .foregroundStyle(Color.asset(.gray800))
        .kerning(-0.6)
      
      ZStack {
        Color.asset(.clear)
        Text("해당 재료를 삭제할까요?")
          .font(.asset(.body2))
          .foregroundStyle(Color.asset(.gray500))
        
      }
      .aspectRatio(280/60, contentMode: .fit)
      .frame(maxWidth: .infinity)
      
      HStack(alignment: .center, spacing: 10) {
        Button(action: {}) {
          Text("아니요")
        }.buttonStyle(StateButtonStyle.secondary(.default))
        Button(action: {}) {
          Text("네")
        }.buttonStyle(StateButtonStyle.primary(.default))
      }
    }
  }
}

private extension IngredientInputFormView {
  
  var ingredientInputFormCardListStore: StoreOf<IngredientInputFormCardListCore> {
    return store.scope(state: \.ingredientInputFormCardListState, action: CoreAction.ingredientInputFormCardListAction)
  }
}

#Preview {
  NavigationView {
    IngredientInputFormView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}

