//
//  CNAsyncImage.swift
//  DesignSystem
//
//  Created by 쩡화니 on 7/1/24.
//

import SwiftUI
import Kingfisher
import Common
import DesignSystemFoundation

public struct CNAsyncImage: View {
  
  private var _url: URL?
  private var _placeholder: Image?
  @State private var isLoading: Bool = true
  @State private var progress: Float = 0.0
  
  // MARK: Constructor
  public init(_ url: URL? = nil) {
    self._url = url
  }
  
  public init(_ urlString: String? = nil) {
    self._url = urlString?.asUrl()
  }
  
  // MARK: Body
  public var body: some View {
    return KFImage.url(_url)
      .resizable()
      .scaledToFit()
////      .placeholder {
////        ProgressView()
////      }
//      .onProgress({ receivedSize, totalSize in
//        progress = Float(receivedSize/totalSize)
//      })
//      .onFailure({ error in
//        isLoading = false
//      })
//      .redacted(reason: progress < 1 ? .placeholder : [])
  }
}


#if(DEBUG) && canImport(SwiftUI)

#Preview {
  CNAsyncImage(
    "https://cooknow-s3-image.s3.ap-northeast-2.amazonaws.com/ingredient/strawberry.png"
  )
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity
    )
}

#endif
