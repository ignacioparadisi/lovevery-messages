//
//  AWSDataSource.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

class AWSDataSource: RemoteDataSource {
    
    private let client: HTTPClient
    
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    
    func getChats() async throws -> [String: [Message]] {
        let requestAPI = MessagesAPI.getAllChats
        let response: MessageResponse<[String: [Message]]> = try await client.request(api: requestAPI)
        return response.body ?? [:]
    }
    
    func getChat(for user: String) async throws -> Chat {
        let requestAPI = MessagesAPI.getChatByUser(user: user)
        let response: MessageResponse<Chat> = try await client.request(api: requestAPI)
        guard let responseBody = response.body else {
            throw RequestError.emptyResponse
        }
        return responseBody
    }
    
    func sendMessage(user: String, message: Message) async throws -> MessageBody {
        let body = MessageBody(user: user, message: message, operation: "add_message")
        let requestAPI = MessagesAPI.createMessage(message: body)
        let response: MessageResponse<MessageBody> = try await client.request(api: requestAPI)
        guard let responseBody = response.body else {
            throw RequestError.emptyResponse
        }
        return responseBody
    }
}
