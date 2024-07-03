//
//  CNSegmentControl.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI
import DesignSystemFoundation
import Common


public struct CNSegmentControl<T>: View where T: RawRepresentable, T.RawValue == String, T: Equatable, T: Hashable {
  
  let segments: [T]
  @Binding private var selected: T
  @Namespace private var namespace
  
  public init(
    segments: [T],
    selected: Binding<T>
  ) {
    self.segments = segments
    self._selected = selected
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      ForEach(self.segments, id: \.self) { segment in
        Button(action: {
          self.selected = segment
        }) {
          VStack {
            Text(segment.rawValue)
              .padding(.vertical, 5.5)
              .padding(.horizontal, 28)
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
    .font(Font.asset(.bodyBold3))
    .tint(Color.asset(.gray500))
  }
}

#if(DEBUG)
enum Foods: String, CaseIterable {
  case 과일
  case 채소
  case 고기
}


#Preview {
  @State var selected = Foods.고기
  return CNSegmentControl(
    segments: Foods.allCases,
    selected: $selected
  )
}
#endif
