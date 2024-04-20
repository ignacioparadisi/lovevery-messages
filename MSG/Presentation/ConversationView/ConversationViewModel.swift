//
//  ConversationViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation
import UIKit
import OSLog

extension ConversationView {
    @Observable
    class ViewModel {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ConversationView.ViewModel.self))
        private let repository: MessagesRepository
        private(set) var user: User
        private(set) var isLoading: Bool = false
        private(set) var error: Error?
        var showErrorAlert: Bool = false
        private var task: Task<User, Error>?
        
        var messages: [Message] {
            return user.message
        }
        var title: String {
            return user.user
        }
        
        init(repository: MessagesRepository = HTTPMessagesRepository(), user: User) {
            self.repository = repository
            self.user = User(user: user.user, message: [])
        }
        
        func fetchUser() async {
            guard !isLoading else { return }
            logger.info("Fetching messages for user \(self.user.user)")
            task?.cancel()
            isLoading = true
            error = nil
            defer { 
                isLoading = false
                task = nil
            }
            task = Task { try await repository.getMessages(for: user.user) }
            do {
                self.user = try await task!.value
            } catch {
                logger.error("Error fetching messages for user \(self.user.user): \(error.localizedDescription)")
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
