//
//  HTTPMessagesRepository.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

class HTTPMessagesRepository: MessagesRepository {
    private let dataSource: RemoteDataSource
    init(dataSource: RemoteDataSource = AWSDataSource()) {
        self.dataSource = dataSource
    }
    
    func getMessages() async throws -> [User] {
        let messages = try await dataSource.getMessages()
        let users = messages.keys.map {
            User(user: $0, message: messages[$0] ?? [])
        }
        return users.sorted { $0.user < $1.user }
    }
    
    func getMessages(for user: String) async throws -> User {
        return try await dataSource.getMessages(for: user)
    }
    
    func sendMessage(user: String, message: Message) async throws -> User {
        let response = try await dataSource.sendMessage(user: user, message: message)
        let message = Message(subject: response.subject, message: response.message)
        return User(user: response.user, message: [message])
    }
}
