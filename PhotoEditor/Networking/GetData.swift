//
//  GetData.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

import Foundation

func getData() {
    
    let urlString = "https://eulerity-hackathon.appspot.com/image"
    
    guard let url = URL(string: urlString) else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
        
        guard let data = data, error == nil else {
            return
        }
        
        var result: [Image]?
        do {
            result = try JSONDecoder().decode([Image].self, from: data)
        } catch {
            print("Failed to decode with error: \(error)")
        }
        
        guard let final = result else {
            return
        }
        
        print("JSON Decoded: \(final)")

    })
    
    task.resume()
}
