//
//  MessagesRepository.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import Foundation

protocol MessagesRepository {
    func getMessages() async throws -> [User]
    func getMessages(for user: String) async throws -> User
    @discardableResult
    func sendMessage(user: String, message: Message) async throws -> User
}
