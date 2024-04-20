//
//  RemoteDataSource.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

protocol RemoteDataSource {
    func getMessages() async throws -> [String: [Message]]
    func getMessages(for user: String) async throws -> User
    func sendMessage(user: String, message: Message) async throws -> MessageBody
}
