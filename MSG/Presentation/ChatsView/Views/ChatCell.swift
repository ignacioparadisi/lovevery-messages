//
//  ChatCell.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import SwiftUI

struct ChatCell: View {
    let chat: Chat
    var body: some View {
        VStack(alignment: .leading) {
            Text(chat.user)
                .bold()
            if let message = chat.message.last {
                Text(message.subject)
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(message.message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
        }
    }
}
