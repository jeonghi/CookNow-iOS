//
//  IngredientInputFormCardListView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 9/14/24.
//

import SwiftUI
import ComposableArchitecture
import Common

// MARK: Properties
public struct IngredientInputFormCardListView: BaseFeatureViewType {
  
  public typealias Core = IngredientInputFormCardListCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    public init(state: CoreState) {
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
extension IngredientInputFormCardListView: View {
  
  public var body: some View {
    ZStack {
      
    }
    .ignoresSafeArea(edges: [.horizontal, .top])
    .kerning(-0.6) // 자간 -0.6
  }
}

// MARK: Componet
extension IngredientInputFormCardListView {
  
}

#Preview {
  NavigationView {
    IngredientInputFormCardListView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}

