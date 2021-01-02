//
//  CameraView.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/3/20.
//

import SwiftUI

struct CameraView: View {
    
    @Binding var isShowing: Bool
    @Binding var image: Image?
    @Binding var isWearingMask: Bool
    @Binding var takenPicture: Bool
    @Binding var progressAmount: Double
    
    var body: some View {
        ZStack {
            ImagePicker(isShown: $isShowing, image: $image, isWearingMask: $isWearingMask, takenPicture: $takenPicture, progressAmount: $progressAmount)
        }

    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(isShowing: .constant(false), image: .constant(Image("mask")), isWearingMask: .constant(false), takenPicture: .constant(false), progressAmount: .constant(0.0))
    }
}
