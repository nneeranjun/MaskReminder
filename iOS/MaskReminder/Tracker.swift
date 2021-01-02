//
//  SwiftUIView.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/8/20.
//

import SwiftUI
import MapKit

struct Tracker: View {
    @ObservedObject var locationManager: LocationManager
    var houseLocation: CLLocation
    var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        VStack {
            Text("location status: \(locationManager.statusString)")
            HStack {
                Text("distance from door: \(locationManager.homeDistance(homeLocation: houseLocation)) meters")
            }
            if locationManager.homeDistance(homeLocation: houseLocation) >= 100 {
                Text("Did you remember to wear your mask?")
            }
        }
    }
    
}

struct Tracker_Previews: PreviewProvider {
    static var previews: some View {
        Tracker(locationManager: LocationManager(), houseLocation: CLLocation())
    }
}
