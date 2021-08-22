//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

protocol NetworkClient {
  func request(route: ApiRoute, completion: @escaping(Result<Data, Error>) -> Void)
  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultNetworkClient: NetworkClient {

  private enum HTTPError: Error {
    case server
    case noData
  }

  private let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func request(route: ApiRoute, completion: @escaping(Result<Data, Error>) -> Void) {
    let url = URLBuilder.url(for: route)
    request(with: url) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    session.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
      }
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        completion(.failure(HTTPError.server))
        return
      }
      guard let data = data else {
        completion(.failure(HTTPError.noData))
        return
      }
      completion(.success(data))
    }
    .resume()
  }
}
