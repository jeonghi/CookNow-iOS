//
//  Strings.swift
//  IngredientBox
//
//  Created by 쩡화니 on 7/3/24.
//

import SwiftUI

enum Strings: String {
  case ingredient_box_home_description
  
  var localized: String {
    return NSLocalizedString(self.rawValue, bundle: .module, comment: "")
  }
}

//extension Text {
//  init(_ localizedString: Strings) {
//    self.init("\(localizedString.rawValue)", bundle: .module)
//  }
//}
