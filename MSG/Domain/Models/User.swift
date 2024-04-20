//
//  User.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID = UUID()
    let user: String
    let message: [Message]
    
    enum CodingKeys: String, CodingKey {
        case user
        case message
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let user = try container.decodeIfPresent(String.self, forKey: .user) {
            self.user = user
            self.message = try container.decode([Message].self, forKey: .message)
        } else {
            self.user = ""
            self.message = []
        }
    }
    
    init(user: String, message: [Message]) {
        self.user = user
        self.message = message
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.user == rhs.user
    }
}

extension User: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(user)
    }
}
