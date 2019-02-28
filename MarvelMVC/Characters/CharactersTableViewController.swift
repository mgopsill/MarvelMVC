//
//  CharactersTableViewController.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 22/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController {
    
    private let characterService: CharacterService
    private var characters: [MarvelCharacter]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(characterService: CharacterService) {
        self.characterService = characterService
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        
        title = "Characters"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        characterService.fetchCharacters { result in
            switch result {
            case .success(let model):
                self.characters = model.data.characters
            case .failure(let error):
                print(error)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CharactersTableViewController {
    
    // MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let characters = characters else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        
        let characterForCell = characters[indexPath.row]
        cell.update(with: characterForCell)
        
        return cell
    }
    
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCharacter = characters?[indexPath.row] else { return }
        let detailsViewController = CharacterDetailsViewController(character: selectedCharacter)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
