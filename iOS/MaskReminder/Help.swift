//
//  Help.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/30/20.
//

import SwiftUI

struct Help: View {
    let instructionsText = ["To add a location, click the + button in the home screen.", "Adding a location will create a geofence around your selected location. You will be notified once it has recognized you have left this location.", "To delete a location, swipe left on the cell and hit delete."]
    
    let locationSettingsText = ["You need to share your location in order to allow us to track your current location and send you a notification to remember to wear your mask.", "If you choose 'While Using the App', we will only be able to track your location while you are using the app (this won't be very helpful).","If you want to take full advantage of this app, please select 'Always' under location access :)"]
    
    let notificationSettingsText = ["You need to enable notifications in order to allow us to send you mask reminder notifications!"]
    
    let summaryText = ["This app allows you to save locations such as your home or your workplace and set reminders to wear your mask when you leave these locations."]
    var body: some View {
        ScrollView {
            Group {
                Paragraph(header: "Summary", bullets: summaryText, image: Image(systemName: "heart.text.square.fill"))
            }
            Spacer()
            Group {
                Paragraph(header: "Instructions", bullets: instructionsText, image: Image(systemName: "doc.text.fill"))
            }
            Spacer()
            Group {
                Paragraph(header: "Location Settings", bullets: locationSettingsText, image: Image(systemName: "mappin.circle.fill"))
            }
            Spacer()
            Group {
                Paragraph(header: "Notification Settings", bullets: notificationSettingsText, image: Image(systemName: "text.bubble.fill"))
                Spacer()
            }
            Spacer()
            Button("Change Settings") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(20)
            .foregroundColor(.white)
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct Paragraph: View {
    var header: String
    var bullets: [String]
    var image: Image
    
    var body: some View {
        VStack {
            HStack {
                image
                    .font(.title2)
                Text(header)
                    .font(.title)
                    .multilineTextAlignment(.leading)
               
                Spacer()
            }
            Spacer()
            Divider().background(Color.secondary)
            Spacer()
            ForEach(bullets, id: \.self) { text in
                HStack {
                    Text("\u{2022} \(text)")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
}

struct Help_Previews: PreviewProvider {
    static var previews: some View {
        Help()
    }
}
