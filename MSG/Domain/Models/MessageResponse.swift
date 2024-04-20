//
//  MessageResponse.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

struct MessageResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let body: T?
    
    enum CodingKeys: String, CodingKey {
        case statusCode
        case body
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<MessageResponse<T>.CodingKeys> = try decoder.container(keyedBy: MessageResponse<T>.CodingKeys.self)
        self.statusCode = try container.decode(Int.self, forKey: MessageResponse<T>.CodingKeys.statusCode)
        do {
            self.body = try container.decodeIfPresent(T.self, forKey: MessageResponse<T>.CodingKeys.body)
        } catch {
            if let stringBody = try container.decodeIfPresent(String.self, forKey: MessageResponse<T>.CodingKeys.body),
                      let data = stringBody.data(using: .utf8) {
                self.body = try JSONDecoder().decode(T.self, from: data)
            } else {
                self.body = nil
            }
        }
    }
}
