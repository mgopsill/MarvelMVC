//
//  CharacterDetailsViewControllerTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 28/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterDetailsViewControllerTests: XCTestCase {

    var subject: CharacterDetailsViewController!
    var mockResult: Result!
    
    override func setUp() {
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        mockResult = mockResponseModel.data.results[0]
        
        let navigationController = UINavigationController()
        subject = CharacterDetailsViewController(result: mockResult)
        navigationController.setViewControllers([subject], animated: false)
    }

    override func tearDown() {
        subject = nil
    }

    func testViewDidLoad_SetsTitleToCharacter() {
        subject.simulateViewDidLoad()
        XCTAssertEqual(subject.title, mockResult.name)
    }
    
    func test_DataSourceShouldBeSelf() {
        XCTAssertTrue(subject.tableView.dataSource === subject)
    }
    
    func testTableView_CellTypeIsCharacterDetailsCell() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterDetailsTableViewCell
        XCTAssertNotNil(cell)
    }
}

extension UIViewController {
    func simulateViewDidLoad() {
        _ = self.view
    }
}
