//
//  health_fbApp.swift
//  health_fb
//
//  Created by 伊藤倫 on 2023/04/13.
//

import SwiftUI

@main
struct health_fbApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
