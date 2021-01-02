//
//  SavedLocations.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/25/20.
//

import SwiftUI
import MapKit

struct SavedLocations: View {
    
    @State var alertShowing = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @ObservedObject var locationManager: LocationManager
    @EnvironmentObject var modelData: ModelData
    @State var isEditing = false
    
    var body: some View {
        NavigationView {
            if modelData.isEmpty {
                VStack {
                    Text("Add a location using the button above to start receiving mask reminders!")
                    Spacer()
                }
                .navigationBarItems(leading:
                        NavigationLink(destination: Help()) {
                            Image(systemName: "questionmark.circle")
                        }
                            .font(.title2),
                    trailing:
                        NavigationLink(destination: LocationSelector(locationManager: locationManager, lat: locationManager.currentLocation?.center.latitude ?? 0, lon: locationManager.currentLocation?.center.longitude ?? 0)) {
                            Image(systemName: "plus")
                                .font(.title)
                        }
                        .disabled(modelData.isFull)
                )
                .navigationTitle("My Locations")
                .padding()
            } else {
                VStack {
                    if modelData.isFull {
                        Text("You have reached your maximum of \(modelData.locationLimit) locations tracked. Please delete a location by swiping left on a cell to start adding more locations :)")
                            .padding(.horizontal)
                    }
                    List {
                        ForEach(modelData.locations) { location in
                            Text(location.name ?? "unknown")
                        }
                        .onDelete(perform: { indexSet in
                            for i in indexSet {
                                deleteUnregister(index: i)
                            }
                        })
                    }
                    .shadow(radius: 4)
                    .listStyle(InsetGroupedListStyle())
                    .navigationBarItems(leading:
                            NavigationLink(destination: Help()) {
                                Image(systemName: "questionmark.circle")
                            }
                                .font(.title2),
                        trailing:
                            NavigationLink(destination: LocationSelector(locationManager: locationManager, lat: locationManager.currentLocation!.center.latitude, lon: locationManager.currentLocation!.center.longitude)) {
                                Image(systemName: "plus")
                                    .font(.title)
                            }
                            .disabled(modelData.isFull)
                    )

                        
                }
                    .navigationTitle("My Locations")
            }
        }
        .alert(isPresented: $alertShowing, content: {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
        })
    }
    
    func deleteUnregister(index: Int) {
        let loc = modelData.locations[index]
        do {
            try modelData.delete(index: index)
            locationManager.unregisterLocation(latitude: loc.latitude, longitude: loc.longitude, identifier: loc.name ?? "")
        } catch DeleteError.NonExistant {
            alertTitle = "Cannot Delete"
            alertMessage = "Location does not exist"
            alertShowing = true
        } catch DeleteError.SystemError {
            alertTitle = "System Error"
            alertMessage = "Please try again later"
            alertShowing = true
        } catch {
            print("Unexpected Error \(error)")
        }
    }
}



struct SavedLocations_Previews: PreviewProvider {
    static var previews: some View {
        SavedLocations(locationManager: LocationManager())
            .environmentObject(ModelData())
    }
}
