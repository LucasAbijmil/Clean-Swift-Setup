//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

struct URLBuilder {

  static func url(for route: ApiRoute) -> URL {
    return URL(string: route.path)!
  }
}
