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
//    var mockCharacterService: MockCharacterService!
    var mockViewModel: MockCharacterViewModel!
    
    override func setUp() {
        super.setUp()
//        mockCharacterService = MockCharacterService()
        mockViewModel = MockCharacterViewModel()
        
        let navigationController = UINavigationController()
        subject = CharactersTableViewController(viewModel: mockViewModel)
        navigationController.setViewControllers([subject], animated: false)
    }

    override func tearDown() {
        subject = nil
    }

    func testViewDidLoad_SetsTitleToCharacter() {
        subject.simulateViewDidLoad()
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
    
    func testTableView_DefaultCellTypeIsUITableViewCell() {
        let cell = subject.tableView(subject.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters() {
        subject.simulateViewDidLoad()

        XCTAssertTrue(mockViewModel.fetchCharactersCalled)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters_SucceedsUpdatesTableView() {
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        
        mockViewModel.characters = mockResponseModel.data.characters
            
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), mockResponseModel.data.characters.count)
        
        let firstCell = subject.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CharacterTableViewCell
        XCTAssertEqual(firstCell?.title.text, mockResponseModel.data.characters[0].name)
    }
    
    func test_ViewDidLoad_StartsFetchForCharacters_FailsShowsEmptyTableView() {
        mockViewModel.characters = nil
        subject.simulateViewDidLoad()
        
        XCTAssertEqual(subject.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_ViewDidLoad_WhileFetchingShowsActivityIndicator() {
        let networkDelay = 0.5
        mockViewModel.networkDelay = networkDelay
        mockViewModel.state = .loaded
        subject.simulateViewDidLoad()
        XCTAssertTrue(UIApplication.shared.isNetworkActivityIndicatorVisible)
    }
    
    func test_ViewDidLoad_AfterFetchingDoesNotShowActivityIndicator() {
        mockViewModel.state = .loaded
        subject.simulateViewDidLoad()
        let expectation = XCTestExpectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        XCTAssertFalse(UIApplication.shared.isNetworkActivityIndicatorVisible)
    }
}

class MockCharacterViewModel: CharactersViewModelProtocol {
    var characters: [MarvelCharacter]?
    
    var state: CharactersTableViewState = .loading
    var fetchCharactersCalled: Bool = false
    var networkDelay: TimeInterval?

    func fetchCharacters(then completion: @escaping (CharactersTableViewState) -> Void) {
        fetchCharactersCalled = true
        if let networkDelay = networkDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + networkDelay) {
                completion(self.state)
            }
        } else {
            completion(state)
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
