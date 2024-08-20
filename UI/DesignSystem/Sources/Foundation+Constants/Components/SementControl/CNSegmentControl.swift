//
//  CNSegmentControl.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI
import DesignSystemFoundation
import Common

public struct CNSegmentControl<T>: View where T: Identifiable, T: Hashable {
  
  let segments: [T]
  @Binding private var selected: T
  @Namespace private var namespace
  private let label: (T) -> String
  
  public init(
    segments: [T],
    selected: Binding<T>,
    label: @escaping (T) -> String
  ) {
    self.segments = segments
    self._selected = selected
    self.label = label
  }
  
  public var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 0) {
        ForEach(self.segments, id: \.self) { segment in
          Button(action: {
            self.selected = segment
          }) {
            VStack {
              Text(label(segment))
                .padding(.vertical, 5.5)
                .padding(.horizontal, 28)
            }
            .overlay(alignment: .bottom) {
              ZStack(alignment: .bottom) {
                Capsule()
                  .fill(Color.clear)
                  .frame(height: 0.1)
                if selected == segment {
                  Rectangle()
                    .frame(height: 2)
                    .matchedGeometryEffect(id: "tab", in: namespace)
                }
              }
              .background(Color.asset(.clear))
            }
            .applyIf(segment == self.selected) {
              $0.tint(Color.asset(.primary700))
            }
          }
        }
      }
    }
    .font(Font.asset(.bodyBold3))
    .tint(Color.asset(.gray500))
  }
}
