//
//  ImageAsset.swift
//  DesignSystemFoundation
//
//  Created by 쩡화니 on 6/2/24.
//

import UIKit

public struct ImageAsset {
  
  public struct Format {
    let fileExtension: String
    let convert: (ImageAsset) -> NSObjectProtocol
    
    public init(fileExtension: String, convert: @escaping (ImageAsset) -> NSObjectProtocol) {
      self.fileExtension = fileExtension
      self.convert = convert
    }
  }
  
  var named: String
  var bundle: Bundle
  var format: Format
  
  public init(_ named: String, in bundle: Bundle, format: Format) {
    self.named = named
    self.bundle = bundle
    self.format = format
  }
}

public extension ImageAsset.Format {
  static let image = ImageAsset.Format(fileExtension: "assets") {
    guard let image = UIImage(named: $0.named, in: $0.bundle, with: nil) else {
      fatalError("\($0.named).assets does not exist in Bundle:\($0.bundle)")
    }
    return image
  }
}
