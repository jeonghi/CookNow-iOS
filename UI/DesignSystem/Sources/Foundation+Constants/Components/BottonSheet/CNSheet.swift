//
//  CNSheet.swift
//  DesignSystem
//
//  Created by 쩡화니 on 6/14/24.
//

import SwiftUI
import PopupView
import DesignSystemFoundation
import Common

public extension View {
  func cnSheet<PopupContent: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder view: @escaping () -> PopupContent,
    dismissCallback: (() -> Void)? = nil
  ) -> some View {
    self
      .popup(isPresented: isPresented) {
        ZStack {
          view()
            .padding(.top, 24)
            .padding(.horizontal, 18.5)
            .padding(.bottom, 35)
        }
        .frame(maxWidth: .infinity)
        .background(Color.asset(.white))
        .cornerRadius(8, corners: [.topLeft, .topRight])
      } customize: {
        $0
          .isOpaque(true)
          .type(.toast)
          .position(.bottom)
          .dragToDismiss(true)
          .closeOnTap(false)
          .closeOnTapOutside(true)
          .backgroundColor(Color.asset(.overlayBackground))
          .dismissCallback {
            dismissCallback?()
          }
      }
  }
  
  func cnSheet<Item: Equatable, PopupContent: View> (
    item: Binding<Item?>,
    @ViewBuilder view: @escaping (Item) -> PopupContent,
    dismissCallback: (() -> Void)? = nil
  ) -> some View {
    self
      .popup(item: item) { item in
        ZStack {
          view(item)
            .padding(.top, 24)
            .padding(.horizontal, 18.5)
            .padding(.bottom, 35)
        }
        .frame(maxWidth: .infinity)
        .background(Color.asset(.white))
        .cornerRadius(8, corners: [.topLeft, .topRight])
      } customize: {
        $0
          .isOpaque(true)
          .position(.bottom)
          .dragToDismiss(true)
          .closeOnTap(false)
          .closeOnTapOutside(true)
          .backgroundColor(Color.asset(.overlayBackground))
          .dismissCallback {
            dismissCallback?()
          }
      }
  }
}

#Preview {
  VStack {
    Text("바탕")
  }
  .cnSheet(isPresented: .constant(true)) {
    VStack(alignment: .center, spacing: 0) {
      CNCalendarView()
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
