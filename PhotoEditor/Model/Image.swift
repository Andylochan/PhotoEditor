//
//  Image.swift
//  PhotoEditor
//
//  Created by Andy Lochan on 5/1/21.
//

struct Image {
    let url: String
    let created: String
    let updated: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case created = "created"
        case updated = "updated"
    }
}

