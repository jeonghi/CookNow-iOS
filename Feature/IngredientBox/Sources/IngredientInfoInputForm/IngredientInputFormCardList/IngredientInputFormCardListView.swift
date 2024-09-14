//
//  IngredientInputFormCardListView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 9/14/24.
//

import SwiftUI
import ComposableArchitecture
import Common
import Domain

// MARK: Properties
public struct IngredientInputFormCardListView: BaseFeatureViewType {
  
  public typealias Core = IngredientInputFormCardListCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  @State private var scrollProxy: ScrollViewProxy?
  
  public struct ViewState: Equatable {
    var storageTypeSelectionSheetState: StorageTypeSelectionSheetCore.State?
    var dateSelectionSheetState: DateSelectionSheetCore.State?
    var scrolledIngredientStorageId: IngredientStorage.ID?
    public init(state: CoreState) {
      dateSelectionSheetState = state.dateSelectionSheetState
      storageTypeSelectionSheetState = state.storageTypeSelectionSheetState
      scrolledIngredientStorageId = state.scrolledIngredientStorageId
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
      ingredientStorageFormListSection()
    }
    .ignoresSafeArea(edges: [.horizontal, .top])
    .kerning(-0.6) // 자간 -0.6
    .cnSheet(item: viewStore.binding(
      get: \.dateSelectionSheetState,
      send: CoreAction.updateDateSelectionSheetState
    )) { _ in
      IfLetStore(
        dateSelectionSheetStore,
        then: DateSelectionSheetView.init
      )
    }
    .cnSheet(item: viewStore.binding(
        get: \.storageTypeSelectionSheetState,
        send: CoreAction.updateStorageTypeSelectionSheetState
    )) { _ in
      IfLetStore(
        storagetypeSelectionSheetStore,
        then: StorageTypeSelectionSheetView.init
      )
    }
  }
}

// MARK: Componet
extension IngredientInputFormCardListView {
  
  @ViewBuilder
  func ingredientStorageFormListSection() -> some View {
    ScrollViewReader { proxy in
      LazyVStack(spacing: 20) {
        ForEachStore(
          store.scope(
            state: \.formCardStateList,
            action: CoreAction.formCardAction
          )
        ) {
          IngredientInputFormCardView.init($0)
            .id($0.id)
        }
        .onDelete {
          viewStore.send(.onDelete($0))
        }
        .onAppear {
          self.scrollProxy = proxy
        }
        .onChange(of: viewStore.scrolledIngredientStorageId) { _, newValue in
          withAnimation {
            DispatchQueue.main.async {
              scrollProxy?.scrollTo(newValue)
            }
          }
        }
      } // LazyVStack
    } // ScrollViewReader
  }
}

private extension IngredientInputFormCardListView {
  var dateSelectionSheetStore: Store<DateSelectionSheetCore.State?, DateSelectionSheetCore.Action> {
    return store.scope(state: \.dateSelectionSheetState, action: CoreAction.dateSelectionSheetAction)
  }
  
  var storagetypeSelectionSheetStore: Store<StorageTypeSelectionSheetCore.State?, StorageTypeSelectionSheetCore.Action> {
    return store.scope(state: \.storageTypeSelectionSheetState, action: CoreAction.storageSelctionSheetAction)
  }
}

#if(DEBUG)
@available(iOS 17.0, *)
#Preview {
  NavigationView {
    IngredientInputFormCardListView()
      .environment(\.locale, .init(identifier: "ko"))
  }
}

#endif

