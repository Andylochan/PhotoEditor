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
    
    // GET Images for CollectionView
    func fetchImages(closure: @escaping (Bool?, [Image]?) -> Void) {
        
        let url = "https://eulerity-hackathon.appspot.com/image"
        var images = [Image]()
        
        Alamofire.request(url, method: .get).responseJSON { response in
            
            if response.error != nil {
                closure(nil, nil)
                return
            }
            
            if let data = response.data, let json = try? JSON(data: data) {
                let jsonArray = json.array ?? []
                
                for img in jsonArray {
                    let url = img.dictionaryObject?["url"] as? String ?? ""
                    let created = img.dictionaryObject?["created"] as? String ?? ""
                    let updated = img.dictionaryObject?["updated"] as? String ?? ""
                    
                    let imageToAppend = Image(url: url, created: created, updated: updated)
                    images.append(imageToAppend)
                }
                closure(true, images)
            }
        }
    }
    
    // GET URL for POST request in PostHandler
    func fetchURL(closure: @escaping (Bool?, String?) -> Void) {
        
        let url = "https://eulerity-hackathon.appspot.com/upload"
        
        Alamofire.request(url, method: .get).responseJSON { response in
            guard response.error == nil else {
                closure(false, nil)
                return
            }
            
            if let data = response.data, let json = try? JSON(data: data) {
                let url = json.dictionaryObject?["url"] as? String ?? ""
                closure(true, url)
            }
        }
    }
}
