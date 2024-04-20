//
//  UsersViewModel.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import Foundation
import Observation

extension UsersView {
    @Observable
    class ViewModel {
        private let repository: MessagesRepository
        private(set) var users: [User] = []
        private(set) var isLoading: Bool = false
        private(set) var error: Error?
        
        init(repository: MessagesRepository = HTTPMessagesRepository()) {
            self.repository = repository
        }
        
        func fetchMessages() async throws {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            do {
                self.users = try await repository.getMessages()
            } catch is CancellationError {
                // Do nothing
            } catch {
                self.error = error
                throw error
            }
        }
    }
}
