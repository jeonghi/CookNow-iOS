//
//  CNWebView.swift
//  Setting
//
//  Created by 쩡화니 on 9/12/24.
//

import WebKit
import SwiftUI
import Common

struct CNWebView: View {
  
  @State var url: URL?
  
  var body: some View {
    CNWebViewRepresentable(url: $url)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct CNWebViewRepresentable: UIViewRepresentable {
  
  @Binding var url: URL?
  
  func makeUIView(context: Context) -> WKWebView {
    let view = WKWebView()
    return view
  }
  
  func updateUIView(_ view: WKWebView, context: Context) {
    guard let url else { return }
    
    let urlRequest = URLRequest(url: url)
    view.load(urlRequest)
  }
}
