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
  
  public typealias Core = IngredientInputFormCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  @State private var scrollProxy: ScrollViewProxy?
  
  public struct ViewState: Equatable {
    var ingredientStorageList: [IngredientStorage]
    var scrolledIngredientStorageId: IngredientStorage.ID?
    var isLoading: Bool
    public init(state: CoreState) {
      ingredientStorageList = state.ingredientStorageList
      scrolledIngredientStorageId = state.scrolledIngredientStorageId
      isLoading = state.isLoading
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
    static var doneButtonBottomPadding: CGFloat = 20
  }
}

// MARK: Layout
extension IngredientInputFormView: View {
  
  public var body: some View {
    VStack {
      ScrollView(.vertical) {
        Group {
          _introductionSection
          _adSection
          _ingredientStorageFormListSection
            .padding(.vertical, Metric.contentVerticalPadding)
        }
        .padding(.horizontal, Metric.contentHorizontalPadding)
        
        Divider()
        
        Group {
          _addIngredientSection
            .padding(.vertical, Metric.contentVerticalPadding)
        }
        .padding(.horizontal, Metric.contentHorizontalPadding)
        
        Divider()
      }
      
      _formInputDoneButton
        .padding(.horizontal, Metric.contentHorizontalPadding)
        .padding(.bottom, Metric.doneButtonBottomPadding)
    }
    .cnLoading(viewStore.binding(get: \.isLoading, send: CoreAction.isLoading))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .kerning(-0.6)
  }
}

// MARK: Componet
private extension IngredientInputFormView {
  
  // MARK: Section
  var _introductionSection: some View {
    _introductionLabel
      .hLeading()
  }
  
  var _adSection: some View {
    _adArea
      .hCenter()
  }
  
  var _ingredientStorageFormListSection: some View {
    ScrollViewReader { proxy in
      LazyVStack(spacing: 20) {
        ForEach(
          viewStore.binding(
            get: \.ingredientStorageList,
            send: CoreAction.updateIngredientStorageList
          )
        ) { ingredientStorage in
          IngredientInputFormCardView(ingredientStorage)
            .onCopyIngredient { id in
              withAnimation(.easeOut) {
                _ = { viewStore.send(.copyIngredientStorage(id)) } ()
              }
            }
            .onDateSelection {
              
            }
            .onRemoveIngredient { id in
              withAnimation(.easeOut) {
                _ = { viewStore.send(.deleteIngredientStorage(id)) } ()
              }
            }
            .id(ingredientStorage.id)
        } // ForEach
        .onAppear {
          self.scrollProxy = proxy
        }
        .onChange(of: viewStore.scrolledIngredientStorageId) { _, newValue in
          withAnimation {
            scrollProxy?.scrollTo(newValue)
          }
        }
      } // LazyVStack
    } // ScrollViewReader
  }
  
  var _addIngredientSection: some View {
    HStack {
      _addIngredientSectionLabel
      _addIngredientSectionButton
    }
  }
  
  // MARK: Other Components
  var _introductionLabel: some View {
    Text("내 냉장고에 있는 재료들을 선택하고\n정보를 입력해보세요!")
      .multilineTextAlignment(.leading)
      .lineLimit(2)
      .font(.asset(.caption))
      .foregroundStyle(Color.asset(.gray800))
  }
  
  var _adArea: some View {
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
  
  var _addIngredientSectionButton: some View {
    Button(action: { viewStore.send(.addIngredientButtonTapped) }) {
      Label("재료 추가하기", systemImage: "plus")
    }.buttonStyle(StateButtonStyle.secondary(.addIngredient))
  }
  
  var _addIngredientSectionLabel: some View {
    
    Group {
      Text("더 필요한게 있나요?\n").font(.asset(.subhead2)) +
      Text("빠진 재료가 있다면 추가해보세요").font(.asset(.caption))
    }
    .lineSpacing(5)
    .hLeading()
  }
  
  var _formInputDoneButton: some View {
    Button(action: {}) {
      Text("입력 완료")
    }
    .buttonStyle(StateButtonStyle.primary(.done))
  }
  
  // MARK: Popup
  var _askForRemovePopup: some View {
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

private extension ButtonSize {
  static let addIngredient = ButtonSize(width: 114, height: 40)
}

#Preview {
  NavigationView {
    IngredientInputFormView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}

