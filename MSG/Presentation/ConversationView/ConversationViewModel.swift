//
//  ConversationViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation
import UIKit

extension ConversationView {
    @Observable
    class ViewModel {
        private let repository: MessagesRepository
        private(set) var user: User
        private(set) var isLoading: Bool = false
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
        
        func fetchUser() async throws {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            self.user = try await repository.getMessages(for: user.user)
        }
        
        func copyMessage(message: Message) {
            UIPasteboard.general.string = "\(message.subject)\n\n\(message.message)"
        }
    }
}
