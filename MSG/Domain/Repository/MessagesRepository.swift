//
//  MessagesRepository.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

protocol MessagesRepository {
    func getChats() async throws -> [Chat]
    func getChat(for user: String) async throws -> Chat
    @discardableResult
    func sendMessage(user: String, message: Message) async throws -> Chat
}
