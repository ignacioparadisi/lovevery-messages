//
//  HTTPClient.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

final class HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Decodable>(api: API) async throws -> T {
        let request = try createRequest(api: api)
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private func createRequest(api: API) throws -> URLRequest {
        guard let url = api.url else {
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
