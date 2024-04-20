//
//  SendMessageViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation

extension SendMessageView {
    @Observable
    class ViewModel {
        private let repository: MessagesRepository
        var user: String = ""
        var subject: String = ""
        var message: String = ""
        private(set) var isLoading: Bool = false
        
        init(repository: MessagesRepository = HTTPMessagesRepository()) {
            self.repository = repository
            self.user = UserDefaults.standard.string(forKey: "user") ?? ""
        }
        
        var isFormValid: Bool {
            return !user.isEmpty && !subject.isEmpty && !message.isEmpty
        }
        
        func sendMessage() async throws {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            UserDefaults.standard.set(user, forKey: "user")
            
            do {
                let message = Message(subject: subject, message: message)
                try await repository.sendMessage(user: user, message: message)
            } catch {
                throw error
            }
        }
    }
}
