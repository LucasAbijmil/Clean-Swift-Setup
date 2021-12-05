//
//  Copyright (c) ___YEAR___ Lucas Abijmil. All rights reserved.
//

import Foundation

protocol NetworkClient {
  func request(route: ApiRoute) async throws -> Data
  func request(route: ApiRoute, completion: @escaping(Result<Data, Error>) -> Void)
  
  func request(with url: URL) async throws -> Data
  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class DefaultNetworkClient: NetworkClient {
  
  private enum HTTPError: Error {
    case badReponse
    case noData
  }
  
  private let session: URLSession
  
  init(session: URLSession) {
    self.session = session
  }
  
  func request(route: ApiRoute) async throws -> Data {
    let url = URLBuilder.url(for: route)
    return try await request(with: url)
  }
  
  func request(route: ApiRoute, completion: @escaping(Result<Data, Error>) -> Void) {
    let url = URLBuilder.url(for: route)
    request(with: url, completion: completion)
  }
  
  func request(with url: URL) async throws -> Data {
    let (data, response) = try await session.data(from: url)
    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
      throw HTTPError.badReponse
    }
    return data
  }
  
  func request(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    session.dataTask(with: url) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
        completion(.failure(HTTPError.badReponse))
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
