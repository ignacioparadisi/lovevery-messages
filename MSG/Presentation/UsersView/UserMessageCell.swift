//
//  UserMessageCell.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/20/24.
//

import SwiftUI

struct UserMessageCell: View {
    let user: User
    var body: some View {
        NavigationLink(value: user) {
            VStack(alignment: .leading) {
                Text(user.user)
                    .bold()
                if let message = user.message.last {
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
}
