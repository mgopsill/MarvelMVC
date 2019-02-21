//
//  CharactersTableViewControllerTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 22/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharactersTableViewControllerTests: XCTestCase {

    var subject: CharactersTableViewController!
    
    override func setUp() {
        super.setUp()
        let navigationController = UINavigationController()
        subject = CharactersTableViewController()
        navigationController.setViewControllers([subject], animated: false)
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(subject.view)
    }

    override func tearDown() {
        subject = nil
    }

    func testViewDidLoad_SetsTitleToCharacter() {
        XCTAssertEqual(subject.title, "Characters")
    }
    
    func testViewWillAppear_SetsPrefersLargeTitlesTrue() {
        subject.beginAppearanceTransition(true, animated: true)
        guard let navigationBar = subject.navigationController?.navigationBar else {
            XCTFail("No navigation bar exists")
            return
        }
        
        XCTAssertTrue(navigationBar.prefersLargeTitles)
    }
    
    func test_DataSourceShouldBeSelf() {
        XCTAssertTrue(subject.tableView.dataSource === subject)
    }
    
    func testTableView_NumberOfRowsShouldBeTen() {
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), 10)
    }
    
    func testTableView_CellTypeIsUITableViewCell() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
}
