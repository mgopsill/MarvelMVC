//
//  CharactersViewModelTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 01/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharactersViewModelTests: XCTestCase {

    var subject: CharactersViewModel!
    var mockCharacterService: MockCharacterService!
    
    override func setUp() {
        mockCharacterService = MockCharacterService()
        subject = CharactersViewModel(characterService: mockCharacterService)
    }

    override func tearDown() {
        subject = nil
    }

    func test_FetchCharactersSucceeds_RendersLoaded() {
        var completedState: CharactersTableViewState = .loading
        
        let data = CharacterServiceTests.mockData
        let response = CharacterResponseModel.characterReponseModel(for: data)
        mockCharacterService.modelToReturn = response
        
        let expectation = XCTestExpectation(description: #function)
        subject.fetchCharacters { state in
            completedState = state
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(mockCharacterService.fetchCharactersCalled)
        XCTAssertEqual(completedState, .loaded)
    }
    
    func test_FetchCharactersFails_RendersFailed() {
        var completedState: CharactersTableViewState = .loading
        
        mockCharacterService.modelToReturn = nil
        
        let expectation = XCTestExpectation(description: #function)
        subject.fetchCharacters { state in
            completedState = state
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        XCTAssertTrue(mockCharacterService.fetchCharactersCalled)
        XCTAssertEqual(completedState, .failed)
    }
}

class MockCharacterService: CharacterService {

    var fetchCharactersCalled: Bool = false
    var modelToReturn: CharacterResponseModel?

    override func fetchCharacters(completion: @escaping CharacterServiceCompletion) {
        fetchCharactersCalled = true
        if let model = self.modelToReturn {
            completion(Result.success(model))
        } else {
            completion(Result.failure(TestError.test))
        }
    }
}
