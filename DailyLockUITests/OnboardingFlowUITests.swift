//
//  OnboardingFlowUITests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/27/25.
//

import XCTest


final class OnboardingFlowUITests: XCTestCase {
    
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-resetOnboarding"]
        app.launch()
    }
    
    
    @MainActor
    func testCanSkipOnboarding() {
        let skipButton = app.buttons["skipButton"].firstMatch
        XCTAssert(skipButton.exists, "The 'Skip' button should be visible on the onboarding screen.")
        
        skipButton.tap()
        
        XCTAssert(app.tabBars.element.waitForExistence(timeout: 1), "The main tab bar should be visible after skipping onboarding.")
        XCTAssert(app.tabBars.buttons["Today"].exists, "The 'Today' tab should be visible.")
    }
}
