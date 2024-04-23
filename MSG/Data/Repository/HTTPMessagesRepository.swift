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
    
    func getChats() async throws -> [Chat] {
        let messages = try await dataSource.getChats()
        let chats = messages.keys.map {
            Chat(user: $0, message: messages[$0] ?? [])
        }
        return chats.sorted { $0.user < $1.user }
    }
    
    func getChat(for user: String) async throws -> Chat {
        return try await dataSource.getChat(for: user)
    }
    
    func sendMessage(user: String, message: Message) async throws -> Chat {
        let response = try await dataSource.sendMessage(user: user, message: message)
        let message = Message(subject: response.subject, message: response.message)
        return Chat(user: response.user, message: [message])
    }
}
