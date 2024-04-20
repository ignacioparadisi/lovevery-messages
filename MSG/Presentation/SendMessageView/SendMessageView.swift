//
//  SendMessageView.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import SwiftUI

struct SendMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel = ViewModel()
    let onSendMessage: (() -> Void)?
    var body: some View {
        Form {
            HStack {
                Text("From:")
                    .foregroundStyle(.placeholder)
                TextField("", text: $viewModel.user)
            }
            Divider()
            HStack {
                Text("Subject:")
                    .foregroundStyle(.placeholder)
                TextField("", text: $viewModel.subject)
                    .bold()
            }
            Divider()
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.message)
                if viewModel.message.isEmpty {
                    Text("Message")
                        .foregroundStyle(.placeholder)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .animation(.spring, value: viewModel.message.isEmpty)
                        .allowsHitTesting(false)
                }
            }
        }
        .formStyle(.columns)
        .padding()
        .navigationTitle("New Message")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button {
                        Task(priority: .userInitiated) { @MainActor in
                            do {
                                try await viewModel.sendMessage()
                                onSendMessage?()
                                dismiss()
                            } catch {
                                print(error)
                            }
                        }
                        
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .disabled(!viewModel.isFormValid)
                    .animation(.smooth, value: viewModel.isFormValid)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .disabled(viewModel.isLoading)
        .interactiveDismissDisabled(viewModel.isLoading)
    }
}

#Preview {
    NavigationStack {
        SendMessageView(onSendMessage: nil)
    }
}
