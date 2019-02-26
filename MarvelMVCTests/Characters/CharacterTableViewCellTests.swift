//
//  CharacterTableViewCellTests.swift
//  MarvelMVCTests
//
//  Created by DevPair21 on 22/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class CharacterTableViewCellTests: XCTestCase {
    
    var subject: CharacterTableViewCell!
    var mockResult: Result!
    
    override func setUp() {
        subject = CharacterTableViewCell(style: .default, reuseIdentifier: "test")
        
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        mockResult = mockResponseModel.data.results[0]
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func test_CellUpdatedWithResult_UpdatesName() {
        subject.update(with: mockResult)
        XCTAssertEqual(subject.title.text, mockResult.name)
    }
    
    func test_CellUpdatedWithResult_FetchesImage() {
//        subject.update(with: mockResult)
    }
}
