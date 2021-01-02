//
//  ContentView.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 11/8/20.
//

import SwiftUI
import MapKit


struct LocationSelector: View {
    
    @ObservedObject var locationManager: LocationManager
    @EnvironmentObject var modelData: ModelData
    
    @State var searchText = ""
    @State var alertShowing1 = false
    @State var alertTitle1 = ""
    @State var alertMessage1 = ""
    @State var alertShowing2 = false
    @State var alertTitle2 = ""
    @State var alertMessage2 = ""
    @State var hasPin = false
    @State var lat: Double
    @State var lon: Double
    @State var span: MKCoordinateSpan?
    @State var sheetPresented = false
    @State var text = ""
    @Environment(\.presentationMode) var presentationMode
    
    func invalidName(text: String) -> Bool {
        if text == "" {
            return true
        } else {
            return text[0] == " " || text[text.count - 1] == " "
        }
    }
    
    private var saveButtonColor: Color {
        invalidName(text: text) ? Color.gray : Color.blue
    }
    
    private var locationIndicatorImage: String {
        isShowingCurrentLocation() ? "location.fill" : "location"
    }
    
    var body: some View {
        ZStack {
            MapView(lat: $lat, lon: $lon, span: $span)
                .animation(.easeIn)
                .edgesIgnoringSafeArea(.all)
            VStack {
                TextField("Search For Your Address", text: $searchText, onCommit: {
                    displaySearchLocation()
                })
                    .modifier(TextFieldClearButton(text: $searchText))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .shadow(radius: 25)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
//                    if searchText != "" {
//                        List {
//                            ForEach([1,2,3], id: \.self) { num in
//                                Text(num.description)
//                            }
//                        }
//                        .listStyle(InsetGroupedListStyle())
//                        .background(Color.clear)
//                    }
                Spacer()
            }
        }
        .alert(isPresented: $alertShowing1, content: {
            Alert(title: Text(alertTitle1), message: Text(alertMessage1), dismissButton: .default(Text("Ok")))
        })
        .sheet(isPresented: $sheetPresented, content: {
            VStack {
                TextField("Enter the name of this location", text: $text, onCommit: displaySearchLocation)
                    .padding(10)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                Spacer()
                Button(action: {
                    saveLocation()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Save")
                            .padding([.top, .bottom], 5)
                            .font(.title3)
                        Spacer()
                    }
                })
                .padding()
                .background(saveButtonColor)
                .cornerRadius(20.0)
                .foregroundColor(.white)
                .padding(.horizontal)
                .disabled(invalidName(text: text))
            }
            .alert(isPresented: $alertShowing2, content: {
                Alert(title: Text(alertTitle2), message: Text(alertMessage2), dismissButton: .default(Text("Ok")))
            })
        })
        .navigationBarItems(trailing:
            HStack {
                Button(action: showCurrentLocation) {
                    Image(systemName: "location.fill")
                }
                    .foregroundColor(.primary)
                    .imageScale(.large)
                Spacer()
                Spacer()
                Button(action: {
                    sheetPresented.toggle()
                }, label: {
                    Text("Next")
                })
            }
                            
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Set a Location")
    }
    
    private func displaySearchLocation() {
        locationManager.getLocation(from: searchText) { location in
            if let loc = location {
                lat = loc.latitude
                lon = loc.longitude
                alertShowing1 = false
                span?.latitudeDelta = 0.01
                span?.longitudeDelta = 0.01
            } else {
                //error?
                alertTitle1 = "Invalid Address"
                alertMessage1 = "Please enter a valid address and search again."
                alertShowing1 = true
                searchText = ""
            }
        }
    }
    
    private func showCurrentLocation() {
        locationManager.getCurrentLocation { location in
            if let loc = location {
                let center = loc.center
                lat = center.latitude
                lon = center.longitude
                span?.latitudeDelta = 0.01
                span?.longitudeDelta = 0.01
            } else {
                
            }
        }
        if let center = locationManager.currentLocation?.center {
            lat = center.latitude
            lon = center.longitude
            span?.latitudeDelta = 0.01
            span?.longitudeDelta = 0.01
        } else {
            print("Cannot find current location")
        }
    }
    
    private func isShowingCurrentLocation() -> Bool {
        if let center = locationManager.currentLocation?.center {
            return center.latitude == lat && center.longitude == lon
        } else {
            print("Cannot find current location")
            return false
        }
    }
    
    private func saveLocation() {
        let newLocation = Location(latitude: lat, longitude: lon, name: text.trimmingCharacters(in: .whitespacesAndNewlines))
        do {
            try modelData.save(newLocation)
            registerLocation()
            sheetPresented.toggle()
            presentationMode.wrappedValue.dismiss()
            alertShowing2 = false
        } catch SaveError.DuplicateName {
            alertTitle2 = "Duplicate Name"
            alertMessage2 = "Location name already exists. Please enter a different name for this location"
            alertShowing2 = true
        } catch SaveError.SystemError {
            alertTitle2 = "System Error"
            alertMessage2 = "Please try again later."
            alertShowing2 = true
        } catch SaveError.DuplicateLocation {
            alertTitle2 = "Duplicate Location"
            alertMessage2 = "You have already saved a location with these coordinates. Please re-enter a different location"
            alertShowing2 = true
        } catch {
            print("Unexpected Error \(error)")
        }
    }
    
    private func registerLocation() {
        self.locationManager.registerLocation(latitude: lat, longitude: lon, identifier: text)
    }
}

struct LocationSelector_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelector(locationManager: LocationManager(), lat: LocationManager().currentLocation!.center.latitude, lon: LocationManager().currentLocation!.center.longitude)
            .environmentObject(ModelData())
    }
    
}

struct Location: Identifiable, Codable {
    var id = UUID()
    let latitude: Double
    let longitude: Double
    let name: String?
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

