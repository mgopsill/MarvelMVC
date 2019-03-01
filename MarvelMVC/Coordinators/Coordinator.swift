//
//  Coordinator.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 01/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    var navigationController: UINavigationController { get set }
    
    func start()
    
}
