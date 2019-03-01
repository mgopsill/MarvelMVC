//
//  RootCoordinator.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 01/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class RootCoordinator: Coordinator {

    var navigationController: UINavigationController
    
    var charactersViewController: CharactersTableViewController {
        return CharactersTableViewController(characterService: CharacterService())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = charactersViewController
        navigationController.pushViewController(viewController, animated: false)
    }
}
