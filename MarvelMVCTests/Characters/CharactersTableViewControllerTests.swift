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
    var mockCharacterService: MockCharacterService!
    
    func simulateViewDidLoad() { _ = subject.view }
    
    override func setUp() {
        super.setUp()
        mockCharacterService = MockCharacterService()
        
        let navigationController = UINavigationController()
        subject = CharactersTableViewController(characterService: mockCharacterService)
        navigationController.setViewControllers([subject], animated: false)
    }

    override func tearDown() {
        subject = nil
    }

    func testViewDidLoad_SetsTitleToCharacter() {
        simulateViewDidLoad()
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
    
    func testTableView_CellTypeIsUITableViewCell() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters() {
        simulateViewDidLoad()

        XCTAssertTrue(mockCharacterService.fetchCharactersCalled)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters_SucceedsUpdatesTableView() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "characters", ofType: "json")!
        let data = FileManager().contents(atPath: path)
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data!)
        
        mockCharacterService.modelToReturn = mockResponseModel
            
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), mockResponseModel.data.results.count)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters_FailsShowsEmptyTableView() {
        mockCharacterService.modelToReturn = nil
        simulateViewDidLoad()
        
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_ViewDidLoad_WhileFetchingShowsActivityIndicator() {
        let networkDelay = 0.5
        mockCharacterService.networkDelay = networkDelay
        simulateViewDidLoad()
        XCTAssertTrue(UIApplication.shared.isNetworkActivityIndicatorVisible)
    }
    
    func test_ViewDidLoad_AfterFetchingDoesNotShowActivityIndicator() {
        simulateViewDidLoad()
        let expectation = XCTestExpectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible)
    }
}

class MockCharacterService: CharacterService {
    
    var fetchCharactersCalled: Bool = false
    var modelToReturn: CharacterResponseModel?
    var errorToReturn: Error?
    var networkDelay: TimeInterval?
    
    override func fetchCharacters(completion: @escaping CharacterServiceCompletion) {
        fetchCharactersCalled = true
        if let networkDelay = networkDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + networkDelay) {
                completion(self.modelToReturn, self.errorToReturn)
            }
        } else {
            completion(modelToReturn, errorToReturn)
        }
    }
}

extension CharacterResponseModel {
    static func characterReponseModel(for data: Data) -> CharacterResponseModel {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let model = try? decoder.decode(CharacterResponseModel.self, from: data)
        return model!
    }
}
