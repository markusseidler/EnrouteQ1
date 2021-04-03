//
//  EnrouteQ1App.swift
//  EnrouteQ1
//
//  Created by Markus Seidler on 2/4/21.
//

import SwiftUI
import CoreData

@main
struct EnrouteQ1App: App {
    let persistenceController = PersistenceController.shared
    
    var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    var body: some Scene {
        let airport = Airport.withICAO("KSOF", context: context)
        WindowGroup {
            FlightsEnrouteView(flightSearch: FlightSearch(destination: airport))
                .environment(\.managedObjectContext, context)
                .onAppear {
                    airport.fetchIncomingFlights()
                }
        }
    }
}
