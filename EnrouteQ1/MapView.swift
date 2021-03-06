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
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        
        // hook up coordinator as delegate mkMapView
        mkMapView.delegate = context.coordinator
        mkMapView.addAnnotations(annotations)
        
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
        }
    }
    
    typealias UIViewType = MKMapView
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selection)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKPinAnnotationView(annotation: annotation,  reuseIdentifier: "MapViewAnnotation ")
            view.canShowCallout = true
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation  {
                selection = annotation 
            }
        }
    }
}
