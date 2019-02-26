//
//  CharacterImageServiceTests.swift
//  MarvelMVCTests
//
//  Created by DevPair21 on 26/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterImageServiceTests: XCTestCase {
    
    var subject: CharacterImageService!
    var mockNetworkManager: MockNetworkManager!
    let mockURLRequest = URLRequest(url: URL(string: "test")!)
    
    override func setUp() {
        mockNetworkManager = MockNetworkManager()
        subject = CharacterImageService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func test_FetchCharacterImageSucceeds_ReturnsImage() {
        mockNetworkManager.data = CharacterImageServiceTests.mockImageData
        
        var fetchedImage: UIImage?
        var fetchedError: Error?
        let expectation = XCTestExpectation(description: #function)
        subject.fetchImage(request: mockURLRequest) { (image, error) in
            fetchedImage = image
            fetchedError = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNotNil(fetchedImage)
        XCTAssertNil(fetchedError)
    }
    
    func test_FetchCharacterImageGetsIncorrectData_Errors() {
        let incorrectData = Data(bytes: [0,1,2,3])
        mockNetworkManager.data = incorrectData
        mockNetworkManager.error = TestError.test

        var fetchedImage: UIImage?
        var fetchedError: Error?

        let expectation = XCTestExpectation(description: #function)
        subject.fetchImage(request: mockURLRequest) { (image, error) in
            fetchedImage = image
            fetchedError = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        XCTAssertNil(fetchedImage)
        XCTAssertNotNil(fetchedError)
    }
    
    func test_FetchCharacterImageFails_ReturnsNil() {
        mockNetworkManager.data = nil
        mockNetworkManager.error = TestError.test
        
        var fetchedImage: UIImage?
        var fetchedError: Error?
        let expectation = XCTestExpectation(description: #function)
        subject.fetchImage(request: mockURLRequest) { (image, error) in
            fetchedImage = image
            fetchedError = error
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        
        XCTAssertNil(fetchedImage)
        XCTAssertNotNil(fetchedError)
    }
}

extension CharacterImageServiceTests {
    static var mockImageData: Data {
        let bundle = Bundle(for: self)
        let path = bundle.path(forResource: "test", ofType: "png")!
        return FileManager().contents(atPath: path)!
    }
}
