//
//  UIViewConfigurable.swift
//  Protocols
//
//  Created by 쩡화니 on 6/12/24.
//

import Foundation

@objc
public protocol UIViewConfigurable: AnyObject {
  @objc optional func configView()
  @objc optional func configHierarchy()
  @objc optional func configLayout()
}

public extension UIViewConfigurable {
  func configUI() {
    configView?()
    configHierarchy?()
    configLayout?()
  }
}
