//
//  ImagePicker.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/3/20.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var isWearingMask: Bool
    @Binding var takenPicture: Bool
    @Binding var progressAmount: Double

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image, isWearingMask: $isWearingMask, takenPicture: $takenPicture, progressAmount: $progressAmount)
    }
    
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var isWearingMask: Bool
    @Binding var takenPicture: Bool
    @Binding var progressAmount: Double
    
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, isWearingMask: Binding<Bool>, takenPicture: Binding<Bool>, progressAmount: Binding<Double>) {
        _isShown = isShown
        _image = image
        _isWearingMask = isWearingMask
        _takenPicture = takenPicture
        _progressAmount = progressAmount
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        isShown = false
        takenPicture = true
        progressAmount = 10
        verifyImage(image: uiImage.jpegData(compressionQuality: 1)!) { result in
            switch result {
                case .failure(let error):
                    print(error)
                    self.progressAmount = 0
                case .success(let value):
                    self.isWearingMask = value
                    self.progressAmount = 100
                }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
        progressAmount = 0
    }
}
