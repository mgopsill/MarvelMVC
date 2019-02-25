//
//  CharacterTableViewCell.swift
//  MarvelMVC
//
//  Created by DevPair21 on 22/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
 
    // TODO: Invert dependency
    private var imageService: ImageService = CharacterImageService()
    
    private let title: UILabel = UILabel()
    private let characterImageView: UIImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(characterImageView)
        characterImageView.contentMode = .scaleAspectFit
        
        let constraints:[NSLayoutConstraint] = [
            contentView.heightAnchor.constraint(equalToConstant: 100.0),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.0),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 20.0),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with result: Result) {
        title.text = result.name
        
        guard let url = result.imageURL else { return }
        imageService.fetchImage(request: URLRequest(url: url)) { [weak self] (image, error) in
            self?.characterImageView.image = image
        }
    }
}
