//
//  IngredientBoxCore.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/14/24.
//

import ComposableArchitecture
import Foundation

public struct IngredientBoxCore: Reducer {
  
  public init() {
    
  }
  
  public struct State {
    
    var isLoading: Bool
    var searchText: String = ""
    var selectedType: IngredientType = .mockData[0]
    
    public init(
      isLoading: Bool = false
    ) {
      self.isLoading = isLoading
    }
  }
  
  public enum Action {
    /// Life Cycle
    case onLoad
    case onAppear
    case onDisappear
    case isLoading(Bool)
    
    case updateSearchText(String)
    case selectType(IngredientType)
  }
  
  public var body: some ReducerOf<Self> {
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
      case .onDisappear:
        return .none
      case .onLoad:
        return .none
      case .isLoading(let isLoading):
        state.isLoading = isLoading
        return .none
      case .updateSearchText(let newSearchText):
        state.searchText = newSearchText
        return .none
      case .selectType(let selectedType):
        state.selectedType = selectedType
        return .none
      }
    }
  }
}

public extension IngredientBoxCore {
  
  typealias IngredientType = MockIngredientType
  
  struct MockIngredientType: Identifiable, Hashable, Equatable, RawRepresentable {
    
    static let mockData: [Self] = [
      .init("과일"),
      .init("고기")
    ]
    
    public typealias RawValue = String
    
    public let id: UUID = .init()
    let name: String
    public var rawValue: RawValue { name }
    
    init(_ name: String) {
      self.name = name
    }
    
    public init?(rawValue: RawValue) {
      self.init(rawValue)
    }
  }
}
