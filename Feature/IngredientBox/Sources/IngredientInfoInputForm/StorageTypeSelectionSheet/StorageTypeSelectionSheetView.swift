//
//  StorageTypeSelectionSheetView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 9/12/24.
//

import Foundation
import Domain
import SwiftUI
import Common
import DesignSystemFoundation
import DesignSystem
import ComposableArchitecture


// MARK: Properties
public struct StorageTypeSelectionSheetView: BaseFeatureViewType {
  
  typealias SelectionType = Core.SelectionType
  public typealias Core = StorageTypeSelectionSheetCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    var selection: SelectionType
    public init(state: CoreState) {
      selection = state.selection
    }
  }
  
  public init(
    _ store: StoreOf<Core>
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
}

// MARK: Layout
extension StorageTypeSelectionSheetView: View {
  
  public var body: some View {
    ZStack {
      List() {
        Section {
          Picker("", selection: viewStore.binding(get: \.selection, send: CoreAction.typeTapped)) {
            ForEach(SelectionType.allCases, id: \.self) { type in
              Text(type.rawValue)
                .hLeading()
                .padding(.vertical, 12)
                .tag(type)
            }
          }
          .pickerStyle(.inline)
          .listSectionSeparator(.hidden)
          .listRowSeparator(.hidden)
          .listRowInsets(.init())
        } header: {
          Text("보관상태")
            .hLeading()
            .font(.asset(.subhead2))
        }
        .foregroundStyle(Color.asset(.gray800))
        .listRowInsets(.init())
      }
      .scrollIndicators(.hidden)
      .listSectionSeparator(.hidden)
      .listStyle(.plain)
      .tint(Color.asset(.primary500))
      .frame(maxHeight: 300)
    }
    .kerning(-0.6) // 자간 -0.6
  }
}
