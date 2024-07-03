//
//  IngedientBoxView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI
import DesignSystem
import Common

// MARK: Properties
public struct IngedientBoxView {
  
  struct MockIngredientType: Identifiable, Hashable, Equatable, RawRepresentable {
    
    static let mockData: [Self] = [
      .init("과일"),
      .init("고기")
    ]
    
    typealias RawValue = String
    
    let id: UUID = .init()
    let name: String
    var rawValue: RawValue { name }
    
    init(_ name: String) {
      self.name = name
    }
    
    init?(rawValue: RawValue) {
      self.init(rawValue)
    }
  }
  
  @State var searchText: String = ""
  @State var selectedType: MockIngredientType = .mockData[0]
  typealias IngredientType = MockIngredientType
  
  public init() {
    
  }
}

// MARK: Layout
extension IngedientBoxView: View {
  
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
extension IngedientBoxView {
  
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
      text: $searchText,
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
      segments: IngredientType.mockData,
      selected: $selectedType
    )
    .frame(height: 35)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  NavigationView {
    IngedientBoxView()
      .toolbar {
        ToolbarItemGroup(placement: .principal) {
          Text("재료함")
            .font(.asset(.title1))
        }
      }
      .environment(\.locale, .init(identifier: "ko"))
  }
}
