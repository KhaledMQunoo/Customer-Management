//
//  Customer_ManagementApp.swift
//  Customer Management
//
//  Created by Khaled on 12/06/2025.
//

import SwiftUI

@main
struct Customer_ManagementApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashRootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
