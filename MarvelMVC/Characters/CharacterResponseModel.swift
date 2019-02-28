//
//  CharacterResponseModel.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 23/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

struct CharacterResponseModel: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let characters: [MarvelCharacter]
    
    enum CodingKeys: String, CodingKey {
        case characters = "results"
    }
}

struct MarvelCharacter: Codable {
    let name, description: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case jpg = "jpg"
}

extension MarvelCharacter {
    var imageURL: URL? {
        let urlString = String("\(thumbnail.path).\(thumbnail.thumbnailExtension.rawValue)")
        return Foundation.URL(string: urlString)
    }
}
