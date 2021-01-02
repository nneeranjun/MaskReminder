//
//  MaskReminderApp.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/8/20.
//

import SwiftUI
import MapKit
import Firebase
import UserNotifications

@main
struct MaskReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            //LocationSelector(locationManager: locationManager, searchText: .constant(""), lat: locationManager.currentLocation!.center.latitude, lon: locationManager.currentLocation!.center.longitude)
            //Tracker()
            //ImagePicker(isShown: .constant(true), image: .constant(Image("mask")))
            //SwiftUIView()
            SavedLocations(locationManager: locationManager)
                .environmentObject(ModelData())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Configure Firebase
        FirebaseApp.configure()
        //Configure Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Permission granted: \(granted)")
        }
        application.registerForRemoteNotifications()
//        verifyImage { result in
//            switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let value):
//                    print(value)
//                }
//        }
        return true
    }
    
}
