//
//  Flight+Extension.swift
//  EnrouteQ1
//
//  Created by Markus Seidler on 3/4/21.
//

import CoreData

extension Flight {
    var arrival: Date {
        get { arrival_ ?? Date(timeIntervalSinceReferenceDate: 0) }
        set { arrival_ = newValue }
    }
    
    var ident: String {
        get { ident_ ?? "Unknown" }
        set { ident_ = newValue }
    }
    
    var destination: Airport {
        get { destination_! }
        set { destination_ = newValue }
    }
    
    var origin: Airport {
        get { origin_! }
        set { origin_ = newValue }
    }
    
    var airline: Airline {
        get { airline_! }
        set { airline_ = newValue }
    }
    
    var number: Int {
        Int(String(ident.drop(while: { !$0.isNumber }))) ?? 0
    }
    
}

extension Flight {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Flight> {
        let request = NSFetchRequest<Flight>(entityName: "Flight")
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "arrival_", ascending: true)]
        
        return request 
        
    }
}

extension Flight { // should probably be Identifiable & Comparable
    @discardableResult
    static func update(from faflight: FAFlight, in context: NSManagedObjectContext) -> Flight {
        let request = fetchRequest(NSPredicate(format: "ident_ = %@", faflight.ident))
        let results = (try? context.fetch(request)) ?? []
        let flight = results.first ?? Flight(context: context)
        
        flight.ident = faflight.ident
        flight.origin = Airport.withICAO(faflight.origin, context: context)
        flight.destination = Airport.withICAO(faflight.destination, context: context)
        flight.arrival = faflight.arrival
        flight.departure = faflight.departure
        flight.filed = faflight.filed
        flight.aircraft = faflight.aircraft
        flight.airline = Airline.withCode(faflight.airlineCode, in: context)
        flight.objectWillChange.send()
        // might want to save() here
        // Flights are currently only loaded from Airport.fetchIncomingFlights()
        // which saves
        // but it might be nice if this method could stand on its own and save itself
        return flight
    }
    
}
