//
//  API.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

protocol API {
    var method: HTTPMethod { get }
    var scheme: HTTPScheme { get }
    var host: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var body: Encodable? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPScheme: String {
    case http
    case https
}
