//
//  SendMessageViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation
import OSLog

extension SendMessageView {
    @Observable
    class ViewModel {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: SendMessageView.ViewModel.self))
        private let repository: MessagesRepository
        var user: String = ""
        var subject: String = ""
        var message: String = ""
        private(set) var isLoading: Bool = false
        private(set) var error: Error?
        var showErrorAlert: Bool = false
        
        init(repository: MessagesRepository = HTTPMessagesRepository()) {
            self.repository = repository
            self.user = UserDefaults.standard.string(forKey: "user") ?? ""
        }
        
        var isFormValid: Bool {
            return !user.isEmpty && !subject.isEmpty && !message.isEmpty
        }
        
        func sendMessage() async {
            guard !isLoading else { return }
            logger.info("Sending message")
            error = nil
            isLoading = true
            defer { isLoading = false }
            UserDefaults.standard.set(user, forKey: "user")
            
            do {
                let message = Message(subject: subject, message: message)
                try await repository.sendMessage(user: user, message: message)
            } catch is CancellationError {
                // Do nothing
            } catch {
                logger.error("Error sending message: \(error.localizedDescription)")
                self.error = error
                showErrorAlert = true
            }
        }
    }
}
