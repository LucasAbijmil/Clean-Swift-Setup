//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

protocol DecoderService {
  func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T
}

struct DefaultDecoderService: DecoderService {

  private var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
    return try decoder.decode(type, from: data)
  }
}
