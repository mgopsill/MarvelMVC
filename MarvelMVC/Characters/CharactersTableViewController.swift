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
    private var characters: [Result]? {
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
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "Character")
        title = "Characters"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        characterService.fetchCharacters { (model, error) in
            self.characters = model?.data.results
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        
        let characterForCell = characters[indexPath.row]
        cell.update(with: characterForCell)
        
        return cell
    }
}
