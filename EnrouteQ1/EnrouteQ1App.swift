//
//  EnrouteQ1App.swift
//  EnrouteQ1
//
//  Created by Markus Seidler on 2/4/21.
//

import SwiftUI

@main
struct EnrouteQ1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
