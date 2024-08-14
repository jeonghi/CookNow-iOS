//
//  DateSelectionSheetView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/29/24.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import DesignSystemFoundation
import Common

// MARK: Properties
public struct DateSelectionSheetView: BaseFeatureViewType {
  
  public typealias Core = DateSelectionSheetCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    var selectedDate: Date
    public init(state: CoreState) {
      selectedDate = state.selectedDate
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State(ingredientID: UUID(), selection: Date())
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
}

// MARK: Layout
extension DateSelectionSheetView: View {
  
  public var body: some View {
    ZStack {
      VStack {
        CNCalendarView(
          selection: viewStore.binding(
            get: \.selectedDate,
            send: CoreAction.selectDate
          )
        )
        .tint(Color.asset(.primary500))
        .font(.asset(.bodyBold1))
        .aspectRatio(338/356, contentMode: .fit)
        .frame(maxWidth: .infinity)
        
        HStack(alignment: .center, spacing: 10) {
          Button(action: {viewStore.send(.cancelButtonTapped)}) {
            Text("취소")
          }.buttonStyle(StateButtonStyle.secondary(.default))
          Button(action: {viewStore.send(.confirmButtonTapped)}) {
            Text("수정")
          }.buttonStyle(StateButtonStyle.primary(.default))
        }
      }
    }
    .ignoresSafeArea(edges: [.horizontal, .top])
    .kerning(-0.6) // 자간 -0.6
  }
}

// MARK: Componet
extension DateSelectionSheetView {
  
}

#Preview {
  NavigationView {
    DateSelectionSheetView()
      .environment(\.locale, .init(identifier: "ko"))
      .padding()
  }
}

