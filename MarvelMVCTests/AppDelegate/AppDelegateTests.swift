//
//  AppDelegateTests.swift
//  MarvelMVCTests
//
//  Created by Mike Gopsill on 22/01/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import XCTest
@testable import MarvelMVC

class AppDelegateTests: XCTestCase {

    var subject: AppDelegate!
    
    override func setUp() {
        subject = AppDelegate()
        _ = subject.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
    }

    override func tearDown() {
        subject = nil
    }

    func testAppDelegateLaunch_CreatesWindow() {
        XCTAssertNotNil(subject.window)
    }
    
    func testAppDelegateLaunch_SetsUpRootViewControllerCorrectly() {
        guard let rootViewController = subject.window?.rootViewController else {
            XCTFail("No rootViewController")
            return
        }
        
        let navigationController = rootViewController as? UINavigationController
        XCTAssertNotNil(navigationController)
        
        let charactersTableViewController = navigationController?.topViewController as? CharactersTableViewController
        XCTAssertNotNil(charactersTableViewController)
    }
}
