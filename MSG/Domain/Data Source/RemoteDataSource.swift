//
//  RemoteDataSource.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

protocol RemoteDataSource {
    func getChats() async throws -> [String: [Message]]
    func getChat(for user: String) async throws -> Chat
    func sendMessage(user: String, message: Message) async throws -> MessageBody
}
