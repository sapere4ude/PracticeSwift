//
//  combineApiTutorialApp.swift
//  combineApiTutorial
//
//  Created by Kant on 2022/08/13.
//

import SwiftUI

@main
struct combineApiTutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
