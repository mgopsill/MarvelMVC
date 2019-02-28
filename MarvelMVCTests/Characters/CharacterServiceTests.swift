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
        let data = CharacterServiceTests.mockData
        
        mockNetworkManager.data = data
        var result: Result<CharacterResponseModel>?
        let expectation = XCTestExpectation(description: #function)
        subject.fetchCharacters { fetchedResult in
            result = fetchedResult
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        
        let testResult = try? result?.resolve()
        XCTAssertNotNil(testResult??.data.characters)
    }
    
    func test_FetchCharactersGetsIncorrectDataDoesSomething() {
//        let incorrectData = Data(bytes: [0,1,2,3])
//        mockNetworkManager.data = incorrectData
//        mockNetworkManager.error = TestError.test
//
//        var result: Result<CharacterResponseModel>
//        let expectation = XCTestExpectation(description: #function)
//        subject.fetchCharacters { fetchedResult in
//            result = fetchedResult
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.1)
//
//        let testResult = try? result.resolve()
//        XCTAssertNotNil(testResult)
    }
    
    func test_FetchCharactersFailsReturnsNil() {
//        mockNetworkManager.data = nil
//        mockNetworkManager.error = TestError.test
//
//        var fetchedModel: CharacterResponseModel?
//        var fetchedError: Error?
//
//        let expectation = XCTestExpectation(description: #function)
//        subject.fetchCharacters { (characterResponseModel, error) in
//            fetchedModel = characterResponseModel
//            fetchedError = error
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.1)
//
//        XCTAssertNil(fetchedModel)
//        XCTAssertNotNil(fetchedError)
    }
}

class MockNetworkManager: NetworkManaging {
    
    var data: Data?
    var error: Error?
    
    var fetchCalled: Bool = false
    func fetch(request: URLRequest, completeOnMainThread: Bool, completion: @escaping ServiceCompletion) -> URLSessionDataTaskProtocol {
        fetchCalled = true
        
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

extension CharacterServiceTests {
    static var mockData: Data {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: "characters", ofType: "json")!
        return FileManager().contents(atPath: path)!
    }
}
