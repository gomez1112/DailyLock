//
//  TabBarsTests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/27/25.
//

import StoreKitTest
import XCTest

final class DailyLockUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        let session = try SKTestSession(configurationFileNamed: "Configuration")
        session.disableDialogs = true          // no system alerts during tests
        session.clearTransactions()
        
        app = XCUIApplication()
        app.launchArguments = ["enable-testing", "skipOnboarding"]
        app.launch()
    }
    
//    @MainActor
//    func testTabBarsExist() {
//        XCTAssert(app.tabBars.element.exists, "There should be a tab bar.")
//    }
    
    @MainActor
    func testAppStartWithTabsBar() {
        XCTAssert(app.tabBars.buttons["Today"].exists, "There should be a today button at launch.")
        XCTAssert(app.tabBars.buttons["Timeline"].exists, "There should be a calendar button at launch.")
        XCTAssert(app.tabBars.buttons["Insights"].exists, "There should be a insights button at launch.")
        XCTAssert(app.tabBars.buttons["Settings"].exists, "There should be a settings button at launch.")
    }
    
    @MainActor
    func testCanNavigateToDetailViewAndCloseIt() {
        let timelineExists = app.tabBars.buttons["Timeline"].exists
        let scrollView = app.scrollViews.firstMatch
        
        app.buttons["Timeline"].firstMatch.tap()
        XCTAssert(timelineExists, "Should navigate to the Timeline screen.")
        
        XCTAssert(scrollView.waitForExistence(timeout: 1), "The scroll view with entries should exist.")
        scrollView.tap()
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}

