//
//  DailyLockUITests.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//


import XCTest

@MainActor
final class DailyLockUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Launch Test
    
    func testLaunch() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            launch()
        }
    }
    
    // MARK: - Helper Methods
    
    /// A helper to launch the app with specific arguments for a clean test state.
    private func launch(arguments: [String] = []) {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"] + arguments
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
}