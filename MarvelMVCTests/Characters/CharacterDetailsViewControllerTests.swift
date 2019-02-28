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
    var mockCharacter: MarvelCharacter!
    
    override func setUp() {
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        mockCharacter = mockResponseModel.data.characters[0]
        
        let navigationController = UINavigationController()
        subject = CharacterDetailsViewController(character: mockCharacter)
        navigationController.setViewControllers([subject], animated: false)
    }

    override func tearDown() {
        subject = nil
    }

    func testViewDidLoad_SetsTitleToCharacter() {
        subject.simulateViewDidLoad()
        XCTAssertEqual(subject.title, mockCharacter.name)
    }
    
    func test_DataSourceShouldBeSelf() {
        XCTAssertTrue(subject.tableView.dataSource === subject)
    }
    
    func testTableView_CellTypeIsCharacterDetailsCell() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterDetailsTableViewCell
        XCTAssertNotNil(cell)
    }
    
    func testViewWillAppear_SetsPrefersLargeTitlesTrue() {
        subject.beginAppearanceTransition(true, animated: true)
        guard let navigationBar = subject.navigationController?.navigationBar else {
            XCTFail("No navigation bar exists")
            return
        }
        
        XCTAssertFalse(navigationBar.prefersLargeTitles)
    }
    
    func testTableView_ShouldHaveOneRow() {
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func testTableViewCell_resultHasDescription_TextShouldBeCorrect() {
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        mockCharacter = mockResponseModel.data.characters[1]
        
        subject = CharacterDetailsViewController(character: mockCharacter)
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterDetailsTableViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, mockCharacter.description)
    }
    
    func testTableViewCell_resultHasNoDescription_TextShouldBeCorrect() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? CharacterDetailsTableViewCell
        XCTAssertEqual(cell?.descriptionLabel.text, "No Description Provided")
    }
}

extension UIViewController {
    func simulateViewDidLoad() {
        _ = self.view
    }
}
