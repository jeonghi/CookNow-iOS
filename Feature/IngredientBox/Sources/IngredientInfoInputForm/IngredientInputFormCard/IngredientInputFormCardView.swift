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

struct IngredientInputFormCardView {
  
  // MARK: Properties
  @Binding var ingredientStorage: IngredientStorage
  
  // MARK: Handlers
  var onCopyIngredient: ((IngredientStorage.ID) -> Void)? = nil
  var onRemoveIngredient: ((IngredientStorage.ID) -> Void)? = nil
  var onDateSelection: (() -> Void)? = nil
  
  // MARK: Initailizer
  init(
    _ ingredientStorage: Binding<IngredientStorage>
  ) {
    self._ingredientStorage = ingredientStorage
  }
}

extension IngredientInputFormCardView: View {
  var body: some View {
    VStack(spacing: 20) {
      HStack(alignment: .top, spacing: 20) {
        _thumbnail
        VStack(alignment: .leading, spacing: 15) {
          HStack {
            _storageTypeSelectionMenu
            Spacer()
            _copyIngredientButton
          }
          
          _ingredientNameLabel
        }
      }
      
      HStack {
        _expirationDateSelectionButton
        Spacer()
        _ingredientAmountCounter
      }
    }
    .kerning(-0.6)
  }
}

// MARK: Components
private extension IngredientInputFormCardView {
  var _copyIngredientButton: some View {
    Button(action: {
      onCopyIngredient?(ingredientStorage.id)
    }) {
      Text("재료 복제")
        .underline()
    }
    .font(.asset(.body2))
    .tint(.asset(.gray800))
  }
  
  var _thumbnail: some View {
    ZStack {
      _ingredientImage
        .overlay(
          _removeButton
            .vBottom()
            .hTrailing()
            .offset(x: 4, y: 4)
        )
    }
  }
  
  var _ingredientImage: some View {
    CNAsyncImage(ingredientStorage.ingredient.imageUrl)
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
        .stroke(Color.asset(.gray200), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
  }
  
  var _ingredientNameLabel: some View {
    Text(ingredientStorage.ingredient.name)
      .font(.asset(.subhead3))
      .foregroundStyle(Color.asset(.gray800))
  }
  
  var _removeButton: some View {
    Button(action: {
      onRemoveIngredient?(ingredientStorage.id)
    }){
      Image(systemName: "minus")
        .foregroundStyle(Color.asset(.white))
        .padding()
        .aspectRatio(1, contentMode: .fit)
        .clipShape(Circle())
        .background(Circle().fill(Color.asset(.danger500)))
        .overlay(Circle().stroke(Color.asset(.gray200), lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/))
    }
    .frame(width: 24, height: 24)
  }
  
  var _storageTypeSelectionMenu: some View {
    Menu {
      ForEach(StorageType.allCases, id: \.self) { type in
        Button(action: {
          ingredientStorage.storageType = type
        }) {
          Label(type.name, systemImage: ingredientStorage.storageType == type ? "checkmark" : "")
        }
      }
    } label: {
      HStack {
        Text(ingredientStorage.storageType.name)
        Image(systemName: "chevron.down")
      }
    }
    .foregroundStyle(
      {
        switch ingredientStorage.storageType {
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
        ingredientStorage.storageType.color
      )
    )
    .overlay(
      RoundedRectangle(cornerRadius: 3).stroke(
        ingredientStorage.storageType.highlight
      )
    )
  }
  
  var _plusButton: some View {
    Button(action: {
      ingredientStorage.quantity += 1
    }){
      Image(systemName: "plus")
    }.buttonStyle(StateButtonStyle.secondary(.big))
      .frame(width: 32, height: 32)
      .disabled(ingredientStorage.quantity >= 99)
  }
  
  var _minusButton: some View {
    Button(action: {
      ingredientStorage.quantity -= 1
    }){
      Image(systemName: "minus")
    }.buttonStyle(StateButtonStyle.secondary(.big))
      .frame(width: 32, height: 32)
      .disabled(ingredientStorage.quantity <= 1)
  }
  
  var _ingredientAmountCounter: some View {
    HStack(spacing: 5) {
      _minusButton
      Text("\(ingredientStorage.quantity)")
        .frame(width: 32, height: 32)
      _plusButton
    }
    .font(.asset(.body2))
  }
  
  var _expirationDateSelectionButton: some View {
    Button(action: {
    }) {
      Text("유통기한:   ")
        .foregroundStyle(Color.asset(.gray500))
      +
      Text(ingredientStorage.formattedString)
        .foregroundStyle(Color.asset(.gray800))
    }
    .font(.asset(.body2))
    .padding(.horizontal, 10)
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
  
  var _datePicker: some View {
    VStack(alignment: .center, spacing: 0) {
      DatePicker(selection: $ingredientStorage.expirationDate) {}
        .datePickerStyle(.graphical)
        .aspectRatio(338/356, contentMode: .fit)
        .frame(maxWidth: .infinity)
      HStack(alignment: .center, spacing: 10) {
        Button(action: {}) {
          Text("취소")
        }.buttonStyle(StateButtonStyle.secondary(.default))
        Button(action: {}) {
          Text("수정")
        }.buttonStyle(StateButtonStyle.primary(.default))
          .disabled(true)
      }
    }
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
  
  //  var focused: Color {
  //    switch self {
  //    case .roomTemperature:
  //      return .asset(.warning700)
  //    case .freezer:
  //      return .asset(.info700)
  //    case .refrigerator:
  //      return .asset(.success700)
  //    }
  //  }
  
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

private extension Domain.IngredientStorage {
  var formattedString: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY. MM. dd"
    return formatter.string(from: expirationDate)
  }
}

extension IngredientInputFormCardView {
  func onCopyIngredient(action: @escaping (IngredientStorage.ID) -> Void) -> Self {
    var view = self
    view.onCopyIngredient = action
    return view
  }
  
  func onRemoveIngredient(action: @escaping (IngredientStorage.ID) -> Void) -> Self {
    var view = self
    view.onRemoveIngredient = action
    return view
  }
  
  func onDateSelection(action: @escaping () -> Void) -> Self {
    var view = self
    view.onDateSelection = action
    return view
  }
}




#if(DEBUG)

struct IngredientInputFormCardPreview: View {
  @State var storageData = IngredientStorage.dummyData
  
  var body: some View {
    IngredientInputFormCardView($storageData)
      .onCopyIngredient { _ in
        print("복제")
      }
      .onRemoveIngredient { _ in
        print("삭제")
      }
      .onDateSelection {
        
      }
      .padding()
  }
}

#Preview {
  IngredientInputFormCardPreview()
}
#endif
