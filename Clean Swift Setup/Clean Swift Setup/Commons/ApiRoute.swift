//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

enum ApiRoute {
  case none

  var path: String {
    switch self {
    case .none:
      return ""
    }
  }
}
