//
//  ContentView.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import SwiftUI

struct UsersView: View {
    @Bindable private var viewModel: ViewModel = ViewModel()
    @State private var presentMessageForm: Bool = false
    @State private var showLoadingIndicator: Bool = false
    var body: some View {
        List {
            ForEach(viewModel.users) { user in
                UserMessageCell(user: user)
            }
        }
        .overlay {
            if showLoadingIndicator {
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
        .alert("Error", isPresented: $viewModel.showErrorAlert, actions: {
            Button {
                viewModel.showErrorAlert = false
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
                        await viewModel.fetchMessages()
                    }
                })
            }
        })
        .animation(.spring, value: viewModel.users)
        .refreshable {
            await viewModel.fetchMessages()
        }
        .task {
            if viewModel.users.isEmpty {
                showLoadingIndicator = true
                await viewModel.fetchMessages()
                showLoadingIndicator = false
            }
        }
    }
}

#Preview {
    UsersView()
}
