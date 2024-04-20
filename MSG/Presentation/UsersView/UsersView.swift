//
//  ContentView.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import SwiftUI

struct UsersView: View {
    @Bindable private var viewModel: ViewModel = ViewModel()
    @State private var showErrorAlert: Bool = false
    @State private var presentMessageForm: Bool = false
    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                UserMessageCell(user: user)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.users.isEmpty {
                Text("You don't have new messages")
            } else {
                EmptyView()
            }
        }
        .navigationDestination(for: User.self, destination: { user in
            ConversationView(viewModel: ConversationView.ViewModel(user: user))
        })
        .alert("Error", isPresented: $showErrorAlert, actions: {
            Button {
                showErrorAlert = false
            } label: {
                Text("Dismiss")
            }
        }, message: {
            Text(viewModel.error?.localizedDescription ?? "")
        })
        .navigationTitle("Messages")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    presentMessageForm = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $presentMessageForm, content: {
            NavigationStack {
                SendMessageView(onSendMessage: {
                    Task {
                        await fetchMessages()
                    }
                })
            }
        })
        .animation(.spring, value: viewModel.users)
        .refreshable {
            await fetchMessages()
        }
        .task {
            await fetchMessages()
        }
    }
    
    func fetchMessages() async {
        do {
            try await viewModel.fetchMessages()
        } catch {
            showErrorAlert = true
        }
    }
}

#Preview {
    UsersView()
}
