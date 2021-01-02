//
//  MapView.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/9/20.
//

import Foundation
import CoreLocation
import Combine
import MapKit
import SwiftUI

struct MapView: View {
    
    @Binding private var lat: Double
    @Binding private var lon: Double
    
    private let initialLatitudinalMetres: Double = 250
    private let initialLongitudinalMetres: Double = 250

    @Binding private var span: MKCoordinateSpan?

    init(lat: Binding<Double>, lon: Binding<Double>, span: Binding<MKCoordinateSpan?>) {
        _lat = lat
        _lon = lon
        _span = span
    }

    private var region: Binding<MKCoordinateRegion> {
        Binding {
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)

            if let span = span {
                return MKCoordinateRegion(center: center, span: span)
            } else {
                return MKCoordinateRegion(center: center, latitudinalMeters: initialLatitudinalMetres, longitudinalMeters: initialLongitudinalMetres)
            }
        } set: { region in
            self.lat = region.center.latitude
            self.lon = region.center.longitude
            self.span = region.span
        }
    }

    var body: some View {
        Map(coordinateRegion: region, interactionModes: .all, showsUserLocation: true, annotationItems: [Location(latitude: self.lat, longitude: self.lon, name: nil)]) { p in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude), tint: .red)
        }
    }
}


