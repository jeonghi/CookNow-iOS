//
//  CNPopup.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/15/24.
//

import SwiftUI
import PopupView
import DesignSystemFoundation

public extension View {
  func cnPopup<PopupContent: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder view: @escaping () -> PopupContent
  ) -> some View {
    self
      .popup(isPresented: isPresented) {
        ZStack {
          view()
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(
          Color.asset(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        )
        .padding(.horizontal, 23.5)
      } customize: {
        $0
          .type(.toast)
          .position(.center)
          .dragToDismiss(true)
          .closeOnTap(false)
          .backgroundColor(Color.asset(.overlayBackground))
      }
  }
}

#if(DEBUG)

#Preview {
  VStack {
    Text("바탕")
  }
  .cnPopup(isPresented: .constant(true)) {
    VStack(alignment: .center, spacing: 16) {
      Text("삭제")
        .font(.asset(.headline1))
        .foregroundStyle(Color.asset(.gray800))
        .kerning(-0.6)
      
      ZStack {
        Color.asset(.clear)
        Text("해당 재료를 삭제할까요?")
          .font(.asset(.body2))
          .foregroundStyle(Color.asset(.gray500))
        
      }
      .aspectRatio(280/60, contentMode: .fit)
      .frame(maxWidth: .infinity)
      
      HStack(alignment: .center, spacing: 10) {
        Button(action: {}) {
          Text("아니요")
        }.buttonStyle(StateButtonStyle.secondary(.default))
        Button(action: {}) {
          Text("네")
        }.buttonStyle(StateButtonStyle.primary(.default))
      }
    }
  }
}

#endif
