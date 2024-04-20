//
//  MessageBody.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation

struct MessageBody: Codable {
    let user: String
    let subject: String
    let message: String
    let operation: String?
    
    init(user: String, message: Message, operation: String) {
        self.user = user
        self.subject = message.subject
        self.message = message.message
        self.operation = operation
    }
}
