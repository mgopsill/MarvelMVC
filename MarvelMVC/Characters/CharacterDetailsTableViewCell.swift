//
//  CharacterDetailsTableViewCell.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 28/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharacterDetailsTableViewCell: UITableViewCell {
    
    private var didUpdateConstraints = false
    
    private let nameLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()
    private let characterImageView: UIImageView = UIImageView()
    
    static let reuseIdentifier = "CharacterDetails"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(characterImageView)

        nameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        descriptionLabel.numberOfLines = 0
        characterImageView.contentMode = .scaleAspectFit
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            let constraints:[NSLayoutConstraint] = [
                characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40.0),
                characterImageView.widthAnchor.constraint(equalToConstant: 200.0),
                characterImageView.heightAnchor.constraint(equalToConstant: 200.0),
                nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 30.0),
                nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
                descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
                descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
                descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
                descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            didUpdateConstraints = true
        }
        super.updateConstraints()
    }
    
    func update(with result: Result, imageService: CharacterImageService = CharacterImageService()) {
        nameLabel.text = result.name
        descriptionLabel.text = result.description == "" ? "No Description Provided" : result.description
        imageService.fetchImage(request: URLRequest(url: result.imageURL!)) { [weak self] (image, error) in
            guard let image = image else { return }
            self?.characterImageView.image = image
        }
        updateConstraints()
    }
}
