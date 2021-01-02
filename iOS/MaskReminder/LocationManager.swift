//
//  LocationManager.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/8/20.
//

import Foundation
import CoreLocation
import Combine
import MapKit
import SwiftUI
import Firebase

class LocationManager: NSObject, ObservableObject {
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 5
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func registerLocation(latitude: Double, longitude: Double, identifier: String) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                 radius: 60, identifier: identifier)
        region.notifyOnEntry = false
        region.notifyOnExit = true
        self.locationManager.startMonitoring(for: region)
    }
    
    func unregisterLocation(latitude: Double, longitude: Double, identifier: String) {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                 radius: 60, identifier: identifier)
        self.locationManager.stopMonitoring(for: region)
    }
    
    var currentLocation: MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        return MKCoordinateRegion(center: self.locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: span)
    }
    
    func getCurrentLocation(completion: @escaping (_ location: MKCoordinateRegion?) -> Void) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        if let loc = locationManager.location {
            completion(MKCoordinateRegion(center: loc.coordinate, span: span))
        } else {
            completion(nil)
        }
    }
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
 
    @Published var region: MKCoordinateRegion? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }

    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    func homeDistance(homeLocation: CLLocation) -> Double {
        return lastLocation?.distance(from: homeLocation) ?? 0
    }

    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let locationManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        self.region = MKCoordinateRegion(center: location.coordinate, span: span)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = "Mask Reminder"
        content.subtitle = "Did You Wear Your Mask?"
        content.body = "We have detected that you have left \(region.identifier). Did you wear your mask?"
        content.sound = .default
        let center =  UNUserNotificationCenter.current()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "ContentIdentifier", content: content, trigger: trigger)
        center.add(request)
    }
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
