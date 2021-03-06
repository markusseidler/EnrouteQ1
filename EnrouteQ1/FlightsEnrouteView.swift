//
//  FlightsEnrouteView.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import CoreData

struct FlightSearch {
    var destination: Airport
    var origin: Airport?
    var airline: Airport?
    var inTheAir: Bool = true
}

extension FlightSearch {
    var predicate: NSPredicate {
        var format = "destination_ = %@"
        var args: [NSManagedObject] = [destination]
        
        if origin != nil {
            format += " and origin_ = %@"
            args.append(origin!)
        }
        
        if airline != nil {
            format += " and airline_ = %@"
            args.append(airline!)
        }
        
        if inTheAir {
            format += "and departure != nil"
        }
        
        return NSPredicate(format: format, argumentArray: args)
        
    }
}

struct FlightsEnrouteView: View {
    
    @Environment (\.managedObjectContext) var context
    
    @State var flightSearch: FlightSearch
    
    var body: some View {
        NavigationView {
            FlightList(flightSearch)
                .navigationBarItems(leading: simulation, trailing: filter)
        }
    }
    
    @State private var showFilter = false
    
    var filter: some View {
        Button("Filter") {
            self.showFilter = true
        }
        .sheet(isPresented: $showFilter) {
            FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
                .environment(\.managedObjectContext, context)
        }
    }
    
    // if no FlightAware credentials exist in Info.plist
    // then we simulate data from KSFO and KLAS (Las Vegas, NV)
    // the simulation time must match the times in the simulation data
    // so, to orient the UI, this simulation View shows the time we are simulating
    var simulation: some View {
        let isSimulating = Date.currentFlightTime.timeIntervalSince(Date()) < -1
        return Text(isSimulating ? DateFormatter.shortTime.string(from: Date.currentFlightTime) : "")
    }
}

struct FlightList: View {
//    @ObservedObject var flightFetcher: FlightFetcher
    
    @FetchRequest var flights: FetchedResults<Flight>

    init(_ flightSearch: FlightSearch) {
//        self.flightFetcher = FlightFetcher(flightSearch: flightSearch)
//        let request = Flight.fetchRequest(NSPredicate(format: "destination_ = %@", flightSearch.destination ))
        let predicate = flightSearch.predicate
        let request = Flight.fetchRequest(predicate)
        _flights = FetchRequest(fetchRequest: request)
    }

//    var flights: [FAFlight] { flightFetcher.latest }
    
    var body: some View {
        List {
            ForEach(flights, id: \.ident) { flight in
                FlightListEntry(flight: flight)
            }
        }
        .navigationBarTitle(title)
    }
    
    private var title: String {
        let title = "Flights"
        if let destination = flights.first?.destination.icao {
            return title + " to \(destination)"
        } else {
            return title
        }
    }
}

struct FlightListEntry: View {
//    @ObservedObject var allAirports = Airports.all
//    @ObservedObject var allAirlines = Airlines.all
    
//    var flight: FAFlight
    @ObservedObject var flight: Flight

    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
            Text(arrives).font(.caption)
            Text(origin).font(.caption)
        }
            .lineLimit(1)
    }
    
    var name: String {
//        return "\(allAirlines[flight.airlineCode]?.friendlyName ?? "Unknown Airline") \(flight.number)"
        return "\(flight.airline.friendlyName) \(flight.number)"
    }

    var arrives: String {
        let time = DateFormatter.stringRelativeToToday(Date.currentFlightTime, from: flight.arrival)
        if flight.departure == nil {
            return "scheduled to arrive \(time) (not departed)"
        } else if flight.arrival < Date.currentFlightTime {
            return "arrived \(time)"
        } else {
            return "arrives \(time)"
        }
    }

    var origin: String {
//        return "from " + (allAirports[flight.origin]?.friendlyName ?? "Unknown Airport")
        return "from "+(flight.origin.friendlyName)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightsEnrouteView(flightSearch: FlightSearch(destination: "KSFO"))
//    }
//}
