//
//  CharacterTableViewCell.swift
//  MarvelMVC
//
//  Created by DevPair21 on 22/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
 
    private var imageService: ImageService = CharacterImageService()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with result: Result) {
        textLabel?.text = result.name
    }
}

protocol ImageService {
    
}

class CharacterImageService: ImageService {
    
}
