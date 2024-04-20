//
//  Message.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: UUID = UUID()
    let subject: String
    let message: String
    
    enum CodingKeys: CodingKey {
        case subject
        case message
    }
}
