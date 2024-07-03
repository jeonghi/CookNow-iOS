//
//  CNSearchBar.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/14/24.
//

#if(canImport(SwiftUI))
import SwiftUI
import Common
import DesignSystemFoundation

@available(iOS 15.0, *)
public struct CNSearchBar: View {
  
  // MARK: Private properties
  @Binding private var _text: String
  @FocusState private var _textFieldIsFocused: Bool // iOS 15+
  @Environment(\.isEnabled) private var _isEnabled: Bool
  
  private let _placeholder: String
  private var _maxLength: Int
  
  private var state: TextFieldState {
    if(_isEnabled) {
      if(_textFieldIsFocused) {
        return .focused
      }
      else {
        return .notFocused
      }
    } else {
      return .disable
    }
  }
  
  // MARK: Initializer
  public init(
    text: Binding<String> = .constant(""),
    placeholder: String = "",
    maxLength: Int = 60
  ) {
    self.__text = text
    self._placeholder = placeholder
    self._maxLength = maxLength
  }
  
  // MARK: Body
  public var body: some View {
    ZStack {
      HStack {
        Image.asset(.magnifyingglass)
          .renderingMode(.template)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
          .foregroundColor(_iconTintColor)
        TextField(_placeholder, text: $_text)
          .textFieldStyle(.plain)
          .tint(_placeholderColor)
          .font(.asset(.body2))
          .kerning(-0.6)
          .disabled(!_isEnabled)
          .focused($_textFieldIsFocused)
          .limitInputLength(value: $_text, length: _maxLength)
        ZStack {
          if(!_text.isEmpty) {
            Button(action: {
              _text = ""
            }){
              Image.asset(.xmark)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(_iconTintColor)
            }
          }
        }
        .frame(width: 24, height: 24)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 12)
    }
    .background(
      _backgroundColor
        .clipShape(RoundedRectangle(cornerRadius: _cornerRadius))
    )
    .overlay(
      RoundedRectangle(cornerRadius: _cornerRadius)
        .stroke(_borderColor, lineWidth: _borderWidth)
    )
    .hideKeyboardWhenTappedAround()
  }
}


private extension CNSearchBar {
  
  enum TextFieldState {
    case notFocused
    case `focused`
    case select
    case disable
  }
  
  var _iconTintColor: Color {
    switch state {
    case .notFocused:
      return .asset(.gray500)
    case .focused, .select:
      return .asset(.black)
    case .disable:
      return .asset(.gray500)
    }
  }
  
  var _placeholderColor: Color {
    switch state {
    case .notFocused:
      return .asset(.gray500)
    case .focused, .select:
      return .asset(.black)
    case .disable:
      return .asset(.gray400)
    }
  }
  
  var _backgroundColor: Color {
    switch state {
    case .notFocused:
      return .asset(.white)
    case .focused, .select:
      return .asset(.white)
    case .disable:
      return .asset(.gray100)
    }
  }
  
  var _borderColor: Color {
    switch state {
    case .notFocused:
      return .asset(.gray200)
    case .focused, .select:
      return .asset(.primary700)
    case .disable:
      return .asset(.clear)
    }
  }
  
  var _borderWidth: CGFloat {
    switch state {
    case .notFocused, .focused, .select:
      return 1
    case .disable:
      return 0
    }
  }
  
  var _cornerRadius: CGFloat {
    return 6
  }
}

#endif

#Preview {
  CNSearchBar(placeholder: "재료를 입력하세요.")
    .padding(.horizontal, 10)
}
