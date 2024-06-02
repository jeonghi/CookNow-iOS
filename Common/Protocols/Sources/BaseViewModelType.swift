//
//  BaseViewModelType.swift
//  Protocols
//
//  Created by 쩡화니 on 6/2/24.
//

import SwiftUI
import Combine

public protocol BaseViewModelType: ObservableObject, AnyObject {
  var cancellables: Set<AnyCancellable> { get }
  associatedtype Input
  associatedtype Output
}
