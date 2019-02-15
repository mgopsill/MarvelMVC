//
//  CharacterServiceTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 23/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterServiceTests: XCTestCase {

    var subject: CharacterService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        subject = CharacterService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        subject = nil
    }

    func test_FetchCharactersSucceedsReturnsCharacterResponseModel() {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "characters", ofType: "json")!
        let data = FileManager().contents(atPath: path)
        
        mockNetworkManager.data = data
        let expectation = XCTestExpectation(description: "Fetchs the character json")
        subject.fetchCharacters { (characterResponseModel, error) in
            XCTAssertNotNil(characterResponseModel)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_FetchCharactersGetsIncorrectDataDoesSomething() {
        let incorrectData = Data(bytes: [0,1,2,3])
        mockNetworkManager.data = incorrectData
        mockNetworkManager.error = TestError.test
        
        let expectation = XCTestExpectation(description: "Fetchs the character json")
        subject.fetchCharacters { (characterResponseModel, error) in
            XCTAssertNil(characterResponseModel)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_FetchCharactersFailsReturnsNil() {
        mockNetworkManager.data = nil
        mockNetworkManager.error = TestError.test
        
        let expectation = XCTestExpectation(description: "Fetchs the character json")
        subject.fetchCharacters { (characterResponseModel, error) in
            XCTAssertNil(characterResponseModel)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}

class MockNetworkManager: NetworkManaging {
    
    var data: Data?
    var error: Error?
    
    func fetch(request: URLRequest, completeOnMainThread: Bool, completion: @escaping ServiceCompletion) -> URLSessionDataTaskProtocol {
        let data = self.data
        let error = self.error
        
        let dataTask = MockURLSessionDataTask {
            completion(data, nil, error)
        }
        dataTask.resume()
        return dataTask
    }
}

enum TestError: Error {
    case test
}
