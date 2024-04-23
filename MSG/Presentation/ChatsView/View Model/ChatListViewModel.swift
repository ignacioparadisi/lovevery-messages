//
//  ChatsViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation
import OSLog

extension ChatListView {
    @Observable
    class ViewModel {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ChatListView.ViewModel.self))
        private let repository: MessagesRepository
        private(set) var chats: [Chat] = []
        private(set) var isLoading: Bool = false
        private(set) var error: Error?
        private var task: Task<[Chat], Error>?
        var showErrorAlert: Bool = false
        
        init(repository: MessagesRepository = HTTPMessagesRepository()) {
            self.repository = repository
        }
        
        func fetchMessages() async {
            guard !isLoading else { return }
            logger.info("Fetching messages")
            task?.cancel()
            isLoading = true
            error = nil
            defer {
                isLoading = false
                task = nil
            }
            task = Task { try await repository.getChats() }
            do {
                self.chats = try await task!.value
            } catch {
                logger.error("Error fetching messages: \(error.localizedDescription)")
                self.error = error
                showErrorAlert = true
            }
        }
    }
}
