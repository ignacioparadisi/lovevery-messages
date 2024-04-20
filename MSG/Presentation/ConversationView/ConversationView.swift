//
//  ConversationView.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import SwiftUI

struct ConversationView: View {
    @Bindable private var viewModel: ViewModel
    @State private var showLoadingIndicator: Bool = false
    
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
            if showLoadingIndicator {
                ProgressView()
            } else {
                EmptyView()
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert, actions: {
            Button {
                viewModel.showErrorAlert = false
            } label: {
                Text("Dismiss")
            }
        }, message: {
            Text(viewModel.error?.localizedDescription ?? "")
        })
        .refreshable {
            await viewModel.fetchUser()
        }
        .task {
            showLoadingIndicator = true
            await viewModel.fetchUser()
            showLoadingIndicator = false
        }
    }
}

#Preview {
    ConversationView(viewModel: ConversationView.ViewModel(user: User(user: "Dan", message: [])))
}
