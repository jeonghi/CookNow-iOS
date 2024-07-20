//
//  IngredientBoxView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture
import Common

// MARK: Properties
public struct IngredientBoxView: BaseFeatureViewType {
  
  public typealias Core = IngredientBoxCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    var searchText: String
    var selectedType: Core.IngredientType
    public init(state: CoreState) {
      searchText = state.searchText
      selectedType = state.selectedType
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

// MARK: Layout
extension IngredientBoxView: View {
  
  public var body: some View {
    
    VStack(spacing: 0) {
      Group {
        _headerSectionBackgroundImage
          .overlay {
            _headerSection
              .vBottom()
              .padding(.horizontal, 20)
              .padding(.bottom, 20)
          }
        
        _ingredientSegmentControl
        
      }
      .background(
        Color.asset(.white)
      )
      
      ScrollView(.vertical, showsIndicators: true) {
        
      }
    }
    .background(
      Color.asset(.bgMain)
    )
    .ignoresSafeArea(edges: [.horizontal, .top])
    .kerning(-0.6) // 자간 -0.6
  }
}

// MARK: Componet
extension IngredientBoxView {
  
  private var _headerSection: some View {
    VStack(spacing: 8) {
      _infoLabel
        .hLeading()
      _searchBar
        .hCenter()
    }
  }
  
  private var _headerSectionBackgroundImage: some View {
    Image.asset(.ingredientBoxHomeHeaderBackground)
      .resizable()
      .scaledToFit()
  }
  
  private var _searchBar: some View {
    CNSearchBar(
      text: viewStore.binding(
        get: \.searchText,
        send: CoreAction.updateSearchText
      ),
      placeholder: "재료를 입력하세요.",
      maxLength: 30
    )
  }
  
  private var _infoLabel: some View {
    Text(
      "내 냉장고에 있는 재료들을 선택하고\n정보를 입력해보세요!"
    )
    .multilineTextAlignment(.leading)
    .font(.asset(.caption))
    .lineLimit(2)
    .foregroundStyle(Color.asset(.gray800))
  }
  
  private var _ingredientSegmentControl: some View {
    CNSegmentControl(
      segments: Core.IngredientType.mockData,
      selected: viewStore.binding(
        get: \.selectedType,
        send: CoreAction.selectType
      )
    )
    .frame(height: 35)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  NavigationView {
    IngredientBoxView()
      .toolbar {
        ToolbarItemGroup(placement: .principal) {
          Text("재료함")
            .font(.asset(.title1))
        }
      }
      .environment(\.locale, .init(identifier: "ko"))
  }
}
