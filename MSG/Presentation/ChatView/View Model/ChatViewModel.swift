//
//  ChatViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation
import UIKit
import OSLog

extension ChatView {
    @Observable
    class ViewModel {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ChatView.ViewModel.self))
        private let repository: MessagesRepository
        private(set) var chat: Chat
        private(set) var isLoading: Bool = false
        private(set) var error: Error?
        var showErrorAlert: Bool = false
        private var task: Task<Chat, Error>?
        
        var messages: [Message] {
            return chat.message
        }
        var title: String {
            return chat.user
        }
        
        init(repository: MessagesRepository = HTTPMessagesRepository(), user: String) {
            self.repository = repository
            self.chat = Chat(user: user, message: [])
        }
        
        func fetchUser() async {
            guard !isLoading else { return }
            logger.info("Fetching messages for user \(self.chat.user)")
            task?.cancel()
            isLoading = true
            error = nil
            defer { 
                isLoading = false
                task = nil
            }
            task = Task { try await repository.getChat(for: chat.user) }
            do {
                self.chat = try await task!.value
            } catch {
                logger.error("Error fetching messages for user \(self.chat.user): \(error.localizedDescription)")
                self.error = error
                showErrorAlert = true
            }
        }
        
        func copyMessage(message: Message) {
            UIPasteboard.general.string = "\(message.subject)\n\n\(message.message)"
            logger.info("Message copied to clipboard")
        }
    }
}
