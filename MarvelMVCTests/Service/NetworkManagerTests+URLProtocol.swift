//
//  NetworkManagerTests+URLProtocol.swift
//  MarvelMVC
//
//  Created by DevPair21 on 21/02/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest

@testable import MarvelMVC

// An alternative way to test URLSession by subclassing URLProtocol

class NetworkManagerTestsURLProtocol: XCTestCase {
    
    var subject: NetworkManaging!
    let request = URLRequest(url: URL(string: "www.test.url.com")!)
    let mockData = Data(bytes: [0,1,0,1])
    
    override func setUp() { }
    
    override func tearDown() {
        subject = nil
    }
    
    func test_NetworkManagerFetchCalled_DataReceived_CallsCompletionWithData() {
        // create the test URL to match the request above
        let url = URL(string: "www.test.url.com")
        
        // in the testURLs dictionary assign some data to the testURL
        URLProtocolMock.testURLs = [url: mockData]
        
        // create a URLSession configuration and assign our mock URLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        // create a session passing our custom configuration
        let session = URLSession(configuration: config)
        
        // create the test subject and run a typical test
        subject = NetworkManager(session: session)
        
        var result: Data?
        let expectation = XCTestExpectation(description: #function)
        subject.fetch(request: request, completeOnMainThread: false) { (data, _, _) in
            result = data
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(result, URLProtocolMock.testURLs[url])
    }
}

fileprivate class URLProtocolMock: URLProtocol {

    // a dictionary of test urls with data we expect back from them
    static var testURLs = [URL?: Data]()
    
    // override with true to say we handle all types of URLRequests
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // must be overridden but can just return original request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // called when load the data, so we immediately any data associated to the URL passed to the URLSession
    override func startLoading() {
        if let url = request.url {
            if let data = URLProtocolMock.testURLs[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // tell the client we finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // must be overridden but we don't have to implement
    override func stopLoading() { }
}
