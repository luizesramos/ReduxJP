//
//  NetworkService.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

final class NetworkService: NetworkServiceable {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession(configuration: .tailored), decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func perform<T: Decodable>(request: NetworkRequest) async throws -> T {
        var r = URLRequest(url: request.url,
                           cachePolicy: request.cachePolicy,
                           timeoutInterval: request.timeout ?? session.configuration.timeoutIntervalForResource)
        r.httpMethod = request.method.rawValue
        r.httpBody = request.body
        Log.network.d("\(r)")
        
        let (data, response) = try await session.data(for: r)
        
        if let httpResponse = response as? HTTPURLResponse {
            Log.network.d("\(httpResponse)")
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.badStatus(httpResponse.statusCode)
            }
        } else {
            Log.network.d("\(response)")
        }

        return try decoder.decode(T.self, from: data)
    }
}

private extension URLSessionConfiguration {
    static var tailored: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 15
        config.httpAdditionalHeaders = [
            "Content-type": "application/json; charset=UTF-8"
        ]
        return config
    }
}
