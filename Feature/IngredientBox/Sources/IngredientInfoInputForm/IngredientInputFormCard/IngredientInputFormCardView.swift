//
//  IngredientInputFormCardView.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/24/24.
//

import SwiftUI
import DesignSystem
import DesignSystemFoundation
import Domain
import Common
import ComposableArchitecture

// MARK: Properties
public struct IngredientInputFormCardView: BaseFeatureViewType {
  
  public typealias Core = IngredientInputFormCardCore
  public let store: StoreOf<Core>
  
  @ObservedObject public var viewStore: ViewStore<ViewState, CoreAction>
  
  public struct ViewState: Equatable {
    
    private var ingredientStorage: IngredientStorage
    var ingredient: Ingredient { ingredientStorage.ingredient }
    var quantity: Int { ingredientStorage.quantity }
    var storageType: StorageType { ingredientStorage.storageType }
    var imageUrl: URL? { ingredient.imageUrl }
    var name: String { ingredient.name }
    var minusButtonEnable: Bool { quantity <= 1 }
    var plusButtonEnable: Bool { quantity >= 99 }
    var expirationDate: String {
      let formatter = DateFormatter()
      formatter.dateFormat = "YYYY / MM / dd"
      return formatter.string(from: ingredientStorage.expirationDate)
    }
    
    public init(state: CoreState) {
      ingredientStorage = state.ingredientStorage
    }
  }
  
  public init(
    _ store: StoreOf<Core> = .init(
      initialState: Core.State(ingredientStorage: .dummyData)
    ){
      Core()
    }
  ) {
    self.store = store
    self.viewStore = ViewStore(store, observe: ViewState.init)
  }
}


extension IngredientInputFormCardView: View {
  public var body: some View {
    VStack(spacing: 20) {
      HStack(alignment: .top, spacing: 20) {
        thumbnail()
        VStack(alignment: .leading, spacing: 15) {
          HStack {
            storageTypeSelectionMenu()
            Spacer()
            copyIngredientButton()
          }
          
          ingredientNameLabel()
        }
      }
      
      HStack {
        expirationDateSelectionButton()
        Spacer()
        ingredientAmountCounter()
      }
    }
    .kerning(-0.6)
  }
}

// MARK: Components
private extension IngredientInputFormCardView {
  @ViewBuilder
  func copyIngredientButton() -> some View {
    Button(action: {
      viewStore.send(.copyIngredient)
    }) {
      Text("재료 복제")
        .underline()
    }
    .font(.asset(.body2))
    .tint(.asset(.gray800))
  }
  
  @ViewBuilder
  func thumbnail() -> some View {
    ZStack {
      ingredientImage()
        .overlay(
          removeButton()
            .vBottom()
            .hTrailing()
            .offset(x: 4, y: 4)
        )
    }
  }
  
  @ViewBuilder
  func ingredientImage() -> some View {
    CNAsyncImage(viewStore.imageUrl)
      .scaledToFit()
      .padding(.horizontal, 3)
      .padding(.vertical, 2)
      .frame(width: 70, height: 70)
      .aspectRatio(1, contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(Color.asset(.gray100))
      )
      .overlay(RoundedRectangle(cornerRadius: 12)
        .stroke(Color.asset(.gray200), lineWidth: 1.0))
  }
  
  @ViewBuilder
  func ingredientNameLabel() -> some View {
    Text(viewStore.name)
      .font(.asset(.subhead3))
      .foregroundStyle(Color.asset(.gray800))
  }
  
  @ViewBuilder
  func removeButton() -> some View {
    Button(action: {
      viewStore.send(.removeIngredient)
    }){
      Image(systemName: "minus")
        .foregroundStyle(Color.asset(.white))
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .clipShape(Circle())
        .background(Circle().fill(Color.asset(.danger500)))
        .overlay(Circle().stroke(Color.asset(.gray200), lineWidth: 1.0))
    }
    .frame(width: 24, height: 24)
  }
  
  @ViewBuilder
  func storageTypeSelectionMenu() -> some View {
    
    Button(action: {
      viewStore.send(.selectStorageType)
    }) {
      HStack {
        Text(viewStore.storageType.name)
        Image(systemName: "chevron.down")
      }
    }
    .foregroundStyle(
      {
        switch viewStore.storageType {
        case .freezer:
          return Color.asset(.white)
        default:
          return Color.asset(.black)
        }
      }()
    )
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
    .font(.asset(.body1))
    .clipShape(RoundedRectangle(cornerRadius: 3))
    .background(
      RoundedRectangle(cornerRadius: 3).fill(
        viewStore.storageType.color
      )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 3).stroke(
        viewStore.storageType.highlight
      )
    )
  }
  
  @ViewBuilder
  func plusButton() -> some View {
    Button(action: {
      viewStore.send(.plusIngredientAmount)
    }){
      Image(systemName: "plus")
    }.buttonStyle(StateButtonStyle.secondary(.big))
      .frame(width: 32, height: 32)
      .disabled(viewStore.plusButtonEnable)
  }
  
  @ViewBuilder
  func minusButton() -> some View {
    Button(action: {
      viewStore.send(.minusIngredientAmount)
    }){
      Image(systemName: "minus")
    }.buttonStyle(StateButtonStyle.secondary(.big))
      .frame(width: 32, height: 32)
      .disabled(viewStore.minusButtonEnable)
  }
  
  @ViewBuilder
  func ingredientAmountCounter() -> some View {
    HStack(spacing: 5) {
      minusButton()
      Text("\(viewStore.quantity)")
        .frame(width: 32, height: 32)
      plusButton()
    }
    .font(.asset(.body2))
  }
  
  @ViewBuilder
  func expirationDateSelectionButton() -> some View {
    Button(action: {
      viewStore.send(.selectDate)
    }) {
      
      HStack(spacing: 15) {
        Text("유통기한:")
          .foregroundStyle(Color.asset(.gray500))
        Text(viewStore.expirationDate)
          .foregroundStyle(Color.asset(.gray800))
      }
    }
    .font(.asset(.body2))
    .padding(.horizontal, 10)
    .padding(.vertical, 6)
    .frame(height: 32)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(Color.asset(.white))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color.asset(.gray300))
    )
  }
}

private extension Domain.StorageType {
  var color: Color {
    switch self {
    case .roomTemperature:
      return .asset(.warning300)
    case .freezer:
      return .asset(.info300)
    case .refrigerator:
      return .asset(.success300)
    }
  }

  var highlight: Color {
    switch self {
    case .roomTemperature:
      return .asset(.warning500)
    case .freezer:
      return .asset(.info500)
    case .refrigerator:
      return .asset(.success500)
    }
  }
  
  var name: String {
    switch self {
    case .roomTemperature:
      return "실온"
    case .freezer:
      return "냉동"
    case .refrigerator:
      return "냉장"
    }
  }
}

#if(DEBUG)

struct IngredientInputFormCardPreview: View {
  var body: some View {
    IngredientInputFormCardView()
  }
}

#Preview {
  IngredientInputFormCardPreview()
}
#endif

