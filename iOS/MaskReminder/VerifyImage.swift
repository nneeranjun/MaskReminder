//
//  VerifyImage.swift
//  MaskReminder
//
//  Created by Nilay Neeranjun on 12/3/20.
//

import Foundation
import Alamofire

func verifyImage(image: Data, closure: @escaping (Result<Bool, Error>) -> Void) {
    //let image = UIImage(named: "mask")!.jpegData(compressionQuality: 1)
    AF.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(image, withName: "image", fileName: "mask.jpg", mimeType: "image/jpg")
    }, to: "http://10.0.0.14:5000/classifier/predict")
    .responseString { response in
        switch response.result {
        case .success(let value):
            closure(.success(Int(value) == 1))
        case .failure(let error):
            closure(.failure(error))
        }
    }
}


