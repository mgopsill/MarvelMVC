//
//  CharacterDetailsViewController.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 28/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UITableViewController {
    
    private let result: Result
    
    init(result: Result) {
        self.result = result
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = result.name
        
        tableView.dataSource = self
        tableView.register(CharacterDetailsTableViewCell.self, forCellReuseIdentifier: CharacterDetailsTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension CharacterDetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailsTableViewCell.reuseIdentifier, for: indexPath) as? CharacterDetailsTableViewCell else { return UITableViewCell() }
        cell.update(with: result)
        return cell
    }
}
