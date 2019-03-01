//
//  AppDelegate.swift
//  MarvelMVC
//
//  Created by Mike Gopsill on 22/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationViewController = UINavigationController()
        let rootCoordinator: Coordinator = RootCoordinator(navigationController: navigationViewController)
        rootCoordinator.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootCoordinator.navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

