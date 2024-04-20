//
//  HTTPClient.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

enum RequestError: Error {
    case invalidURL
    case emptyResponse
}

final class HTTPClient {
    
    func request<T: Decodable>(api: API) async throws -> T {
        let request = try createRequest(api: api)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)

    }
    
    private func createRequest(api: API) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = api.scheme.rawValue
        components.host = api.host
        components.path = api.path
        components.queryItems = api.parameters
        guard let url = components.url else {
            throw RequestError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = api.method.rawValue
        if let body = api.body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        return request
    }
}
