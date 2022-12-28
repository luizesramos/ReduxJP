//
//  NetworkServiceable.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

protocol NetworkServiceable {
    func perform<T: Decodable>(request: NetworkRequest) async throws -> T
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct NetworkRequest {
    let method: HTTPMethod
    let url: URL
    let body: Data?
    let cachePolicy: URLRequest.CachePolicy
    let timeout: TimeInterval?
    
    init(method: HTTPMethod, url: URL,
         body: Data? = nil,
         cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData,
         timeout: TimeInterval? = nil) {
        self.method = method
        self.url = url
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeout = timeout
    }
}

enum NetworkError: Error {
    case badStatus(Int)
    case decodingError
}

extension Log {
    static let network = Logger(context: "Network")
}
