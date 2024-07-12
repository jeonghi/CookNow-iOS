//
//  BaseFeatureType.swift
//  Common
//
//  Created by 쩡화니 on 7/12/24.
//

import ComposableArchitecture

public protocol BaseFeatureViewType {
  associatedtype Core: Reducer
  typealias CoreState = Core.State
  typealias CoreAction = Core.Action
  associatedtype ViewState: Equatable
  var store: StoreOf<Core> { get }
  var viewStore: ViewStore<ViewState, CoreAction> { get }
}
