//
//  CNSegmentControl.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI
import DesignSystemFoundation
import Common

public struct CNSegmentControl<T>: View where T: Hashable {
  
  let segments: [T]
  @Binding private var selected: T
  @Namespace private var namespace
  private let label: (T) -> AnyView
  private var scrollable: Bool
  private var selectedTint: ColorAsset
  private var unselectedTint: ColorAsset
  @State private var scrollProxy: ScrollViewProxy?
  
  public init(
    segments: [T],
    selected: Binding<T>,
    selectedTint: ColorAsset = .primary700,
    unselectedTint: ColorAsset = .gray500,
    scrollable: Bool = true,
    @ViewBuilder label: @escaping (T) -> some View
  ) {
    self.segments = segments
    self._selected = selected
    self.label = { segment in AnyView(label(segment)) }
    self.scrollable = scrollable
    self.selectedTint = selectedTint
    self.unselectedTint = unselectedTint
  }
  
  public var body: some View {
    Group {
      if scrollable {
        ScrollViewReader { proxy in
          ScrollView(.horizontal, showsIndicators: false) {
            contentView()
          }
          .onAppear(perform: {
            self.scrollProxy = proxy
          })
        }
      } else {
        contentView()
      }
    }
    .frame(maxWidth: .infinity)
    .font(Font.asset(.bodyBold3))
    .tint(Color.asset(.gray500))
  }
}

extension CNSegmentControl {
  
  private func contentView() -> some View {
    HStack(spacing: 0) {
      ForEach(self.segments, id: \.self) { segment in
        Button(action: {
          self.selected = segment
          withAnimation(.default) {
            scrollProxy?.scrollTo(segment)
          }
        }) {
          ZStack {
            Color.clear
            label(segment)
          }
          .foregroundStyle(
            (self.selected == segment) ? selectedTint.toColor() : unselectedTint.toColor()
          )
          .padding(.horizontal, 28)
          .overlay(alignment: .bottom) {
            ZStack(alignment: .bottom) {
              Capsule()
                .fill(Color.clear)
                .frame(height: 0.1)
              if selected == segment {
                Rectangle()
                  .frame(height: 2)
                  .matchedGeometryEffect(id: "tab", in: namespace)
                  .offset(y: -1)
              }
            }
            .background(Color.asset(.clear))
          }
          .applyIf(segment == self.selected) {
            $0.tint(Color.asset(.primary700))
          }
        }
        .id(segment)
      }
    }
  }
}
