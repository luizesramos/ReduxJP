//
//  NetworkService.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

protocol NetworkServiceable {
    func perform<T: Decodable>(request: NetworkRequest) async throws -> T
}

struct NetworkRequest {
    let method: HTTPMethod
    let url: URL
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badStatus(Int)
}

final class NetworkService: NetworkServiceable {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession(configuration: .tailored), decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func perform<T: Decodable>(request: NetworkRequest) async throws -> T {
        var r = URLRequest(url: request.url)
        r.httpMethod = request.method.rawValue
        
        let (data, response) = try await session.data(for: r)
        
        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badStatus(httpResponse.statusCode)
            }
        }

        return try decoder.decode(T.self, from: data)
    }
}

private extension URLSessionConfiguration {
    static var tailored: URLSessionConfiguration {
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 15
        return config
    }
}
