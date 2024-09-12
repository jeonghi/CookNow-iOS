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
  
  @State private var url: URL?
  
  init(_ url: URL? = nil) {
    self.url = url
  }
  
  init(_ urlString: String? = nil) {
    self.url = urlString?.asUrl()
  }
  
  var body: some View {
    CNWebViewRepresentable(url: $url)
  }
}

struct CNWebViewRepresentable: UIViewRepresentable {
  
  @Binding var url: URL?
  
  func makeUIView(context: Context) -> some UIView {
    let view = WKWebView()
    
    guard let url else { return view }
    
    let urlRequest = URLRequest(url: url)
    view.load(urlRequest)
    
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}
