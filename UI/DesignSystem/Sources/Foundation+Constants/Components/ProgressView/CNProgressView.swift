//
//  CNProgressView.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/27/24.
//

import SwiftUI

struct CNProgressView: View {
  var body: some View {
    ProgressView()
      .progressViewStyle(CircularProgressViewStyle())
      .padding(20)
      .background(Color.white)
      .cornerRadius(10)
  }
}
