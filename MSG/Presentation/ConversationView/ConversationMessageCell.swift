//
//  ConversationMessageCell.swift
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
