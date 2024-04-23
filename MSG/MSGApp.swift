//
//  MSGApp.swift
//  MSG
//
//  Created by Ignacio Paradisi on 4/17/24.
//

import SwiftUI

@main
struct MSGApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatListView()
            }
        }
    }
}
