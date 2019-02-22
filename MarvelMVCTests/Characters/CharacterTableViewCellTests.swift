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
    
    override func setUp() {
        subject = CharacterTableViewCell(style: .default, reuseIdentifier: "test")
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func test_CellUpdatedWithResult_UpdatesName() {
        let data = CharacterServiceTests.mockData
        let mockResponseModel = CharacterResponseModel.characterReponseModel(for: data)
        let mockResult = mockResponseModel.data.results[0]

        subject.update(with: mockResult)
        XCTAssertEqual(subject.textLabel?.text, mockResult.name)
    }
    
    func test_CellUpdatedWithResult_FetchesImage() {
        // TODO: This test
    }
}
