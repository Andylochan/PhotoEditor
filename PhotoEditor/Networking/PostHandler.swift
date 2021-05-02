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
    
    func fetchURL(closure: @escaping (Bool?, String?) -> Void) {
        
        let url = "https://eulerity-hackathon.appspot.com/upload"
        
        AF.request(url, method: .get).responseJSON { response in
            
            if response.error != nil {
                closure(false, nil)
                return
            }
            
            if let data = response.data {
                
                if let json = try? JSON(data: data) {
                    
                    let url = json.dictionaryObject?["url"] as? String ?? ""
                    
                    print("POST TO \(url)")
                    
                    closure(true, url)
                }
            }
        }
    }
    
    
    //appid: myEmailAdress
    //original: the url of the original file
    //file: a jpeg image file
    func makePostRequest(originalURL: String, editedUIImage: UIImage) {
        
        PostHandler.shared.fetchURL { (res, urlPath) in
            guard let url = urlPath else { return }
            
            let image = editedUIImage // EDITED IMAGE HERE
            let imgData = image.jpegData(compressionQuality: 0.2)!

            let parameters = ["appid": "andylochan97@gmail.com", "original": originalURL] //Optional for extra parameter

            AF.upload(multipartFormData: { multipartFormData in

                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters

                multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")

            },
            to: url)
//            { (result) in
//                switch result {
//                case .success(let upload, _, _):
//
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    })
//
//                    upload.responseJSON { response in
//                         print(response.result.value)
//                    }
//
//                case .failure(let encodingError):
//                    print(encodingError)
//                }
//            }
        }
    }
    
}


