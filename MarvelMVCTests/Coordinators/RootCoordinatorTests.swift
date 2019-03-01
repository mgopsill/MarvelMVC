//
//  RootCoordinatorTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 01/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class RootCoordinatorTests: XCTestCase {
    
    var subject: RootCoordinator!
    var navigationController: UINavigationController!

    override func setUp() {
        navigationController = UINavigationController()
        subject = RootCoordinator(navigationController: navigationController)
    }

    override func tearDown() {
        subject = nil
    }

    func test_Start_PresentsCharactersTableViewController() {
        subject.start()
        let correctViewController = navigationController.topViewController as? CharactersTableViewController
        XCTAssertNotNil(correctViewController)
    }
}
