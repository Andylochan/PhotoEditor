//
//  ImageHandler.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

import Alamofire
import SwiftyJSON

class ImageHandler {
    
    static let shared = ImageHandler()
    private var images = [Image]()
    
    func fetchImages(closure: @escaping (Bool?, [Image]?) -> Void) {
        
        let url = "https://eulerity-hackathon.appspot.com/image"
        
        AF.request(url, method: .get).responseJSON { response in
            
            if response.error != nil {
                closure(nil, nil)
                return
            }
            
            if let data = response.data {
                
                if let json = try? JSON(data: data) {
                    
                    let jsonArray = json.array ?? []
                                        
                    for img in jsonArray {
                        
                        let url = img.dictionaryObject?["url"] as? String ?? ""
                        let created = img.dictionaryObject?["created"] as? String ?? ""
                        let updated = img.dictionaryObject?["updated"] as? String ?? ""
                        
                        let imageToAppend = Image(url: url, created: created, updated: updated)
                        self.images.append(imageToAppend)
                        
                    }
                    
                    closure(true, self.images)
                }
            }
        }
    }
    
}


