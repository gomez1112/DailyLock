//
//  TabBarsTests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/27/25.
//

import XCTest

final class TabBarsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["enable-testing", "skipOnboarding"]
        app.launch()
    }
    
    @MainActor
    func testTabBarsExist() {
        XCTAssert(app.tabBars.element.exists, "There should be a tab bar.")
    }
    
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
}

