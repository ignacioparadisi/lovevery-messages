//
//  ConversationView.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import SwiftUI

struct ConversationMessageCell: View {
    let message: Message
    var body: some View {
        VStack(alignment: .leading) {
            Text(message.subject)
                .bold()
            Divider()
            Text(message.message)
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}

struct ConversationView: View {
    @Bindable private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.messages) { message in
                    ConversationMessageCell(message: message)
                        .contextMenu {
                            Button {
                                viewModel.copyMessage(message: message)
                            } label: {
                                Label("Copy message", systemImage: "doc.on.doc")
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(viewModel.title)
        .defaultScrollAnchor(.bottom)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else {
                EmptyView()
            }
        }
        .refreshable {
            await fetchMessages()
        }
        .task {
            await fetchMessages()
        }
    }
    
    func fetchMessages() async {
        do {
            try await viewModel.fetchUser()
        } catch {
            print(error)
        }
    }
}

#Preview {
    ConversationView(viewModel: ConversationView.ViewModel(user: User(user: "Dan", message: [])))
}
