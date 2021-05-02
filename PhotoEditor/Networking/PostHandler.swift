//
//  PostHandler.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/2/21.
//

import Alamofire
import SwiftyJSON

class PostHandler {
    
    static let shared = PostHandler()
    
    func makePostRequest(originalURL: String, editedUIImage: UIImage) {
        
        ImageHandler.shared.fetchURL { (res, urlPath) in
            guard let url = urlPath else { return }
            
            let image = editedUIImage
            let imgData = image.jpegData(compressionQuality: 0.2)!

            let parameters = ["appid": "andylochan97@gmail.com", "original": originalURL]

            Alamofire.upload(multipartFormData: { multipartFormData in

                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }

                multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")

            },
            to: url)
            { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

                    upload.responseJSON { response in
                        print(response.result.value ?? "")
                    }

                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        }
    }
    
}


