//
//  ExSwiftDataApp.swift
//  ExSwiftData
//
//  Created by Kant on 11/25/23.
//

import SwiftUI
import SwiftData

@main
struct ExSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DataItem.self)
    }
}
