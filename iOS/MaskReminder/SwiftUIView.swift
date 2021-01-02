//
//  SwiftUIView.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/3/20.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var showImagePicker: Bool = false
    @State private var hasTakenPicture: Bool = false
    @State private var isWearingMask: Bool = false
    @State private var image: Image? = nil
    @State private var progressAmount = 0.0
    
    
    var body: some View {
        VStack {
            if progressAmount != 0 && progressAmount != 100 {
                ProgressView("Verifying")
            } else {
                Button("Click to Take a Picture") {
                    showImagePicker = true
                }
                
                if hasTakenPicture {
                    if isWearingMask {
                        Text("You are wearing a mask!")
                    } else {
                        Text("You aren't wearing a mask :(")
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            CameraView(isShowing: $showImagePicker, image: $image, isWearingMask: $isWearingMask, takenPicture: $hasTakenPicture, progressAmount: $progressAmount)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
