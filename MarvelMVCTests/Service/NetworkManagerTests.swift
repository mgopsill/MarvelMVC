//
//  NetworkManagerTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 25/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

class NetworkManagerTests: XCTestCase {
    
    var subject: NetworkManaging!
    var mockSession: MockURLSession!
    let request = URLRequest(url: URL(string: "Test")!)
    let mockData = Data(bytes: [0,1,0,1])

    override func setUp() {
        mockSession = MockURLSession()
        subject = NetworkManager(session: mockSession)
    }

    override func tearDown() {
        subject = nil
    }

    func test_NetworkManagerFetchCalled_StartsARequest() {
        let dataTask = subject.fetch(request: request, completeOnMainThread: false) { (_, _, _) in }
        XCTAssertTrue((dataTask as! MockURLSessionDataTask).resumeCalled)
    }
    
    func test_NetworkManagerFetchCalled_DataReceived_CallsCompletionWithData() {
        mockSession.data = mockData

        var result: Data?
        subject.fetch(request: request, completeOnMainThread: false) { (data, _, _) in
            result = data
        }
        XCTAssertEqual(result, mockData)
    }
    
    func test_NetworkManagerFetchCalled_NoDataReceived_CallsCompletionWithNil() {
        mockSession.data = nil

        var result: Data? = mockData
        subject.fetch(request: request, completeOnMainThread: false) { (data, _, _) in
            result = data
        }
        XCTAssertNil(result)
    }
}

// MARK: Mocking

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let data = self.data
        let error = self.error
        
        return MockURLSessionDataTask(closure: {
            completionHandler(data, nil, error)
        })
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    var resumeCalled: Bool = false
    func resume() {
        resumeCalled = true
        closure()
    }
}
