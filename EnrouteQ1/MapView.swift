//
//  MapView.swift
//  EnrouteQ1
//
//  Created by Markus Seidler on 7/4/21.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    
    let annotations: [MKAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        
        // hook up coordinator as delegate mkMapView
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(annotations)
        
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    typealias UIViewType = MKMapView
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation ")
            view.canShowCallout = true
            
            return view
        }
    }
}
