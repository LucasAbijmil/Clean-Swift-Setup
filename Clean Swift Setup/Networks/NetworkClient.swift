//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

protocol NetworkClient {
  func request(route: ApiRoute, completion: @escaping(Result<Data, Error>) -> Void)
  func request(route: ApiRoute) async -> Result<Data, Error>
  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void)
  func request(with url: URL) async -> Result<Data, Error>
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
    request(with: url, completion: completion)
  }

  func request(route: ApiRoute) async -> Result<Data, Error> {
    let url = URLBuilder.url(for: route)

    return await request(with: url)
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

  func request(with url: URL) async -> Result<Data, Error> {
    do {
      let (data, response) = try await session.data(from: url)
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        return .failure(HTTPError.server)
      }
      return .success(data)
    } catch {
      return .failure(error)
    }
  }
}
