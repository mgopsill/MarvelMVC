//
//  CharactersTableViewController.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 22/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

enum CharactersTableViewState {
    case loading
    case loaded
    case failed
}

class CharactersTableViewController: UITableViewController {
    
    private let viewModel: CharactersViewModelProtocol
    
    init(viewModel: CharactersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        
        title = "Characters"
        render(.loading)
        viewModel.fetchCharacters(then: { [weak self] state in
            self?.render(state)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CharactersTableViewController {
    
    private func render(_ state: CharactersTableViewState) {
        switch state {
        case .loading:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        case .loaded:
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        case .failed:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

extension CharactersTableViewController {
    
    // MARK: TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let characters = viewModel.characters else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        
        let characterForCell = characters[indexPath.row]
        cell.update(with: characterForCell)
        
        return cell
    }
    
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Move to coordinator
        guard let selectedCharacter = viewModel.characters?[indexPath.row] else { return }
        let detailsViewController = CharacterDetailsViewController(character: selectedCharacter)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
