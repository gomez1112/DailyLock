//
//  ConfettiViewTests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/28/25.
//

import Foundation
import XCTest

//@MainActor
//final class ConfettiUITests: XCTestCase {
//    
//    var app: XCUIApplication!
//    
//    override func setUpWithError() throws {
//        
//        continueAfterFailure = false
//        
//        app = XCUIApplication()
//        app.launchArguments = [ "two-day-streak", "skipOnboarding"]
//        app.launch()
//    }
//    
//    func testStreakAchievementView() {
//        // 1. Get UI elements
//        let entryTextField = app.textFields["entryTextView"]
//        let positiveButton = app.segmentedControls.buttons["Positive"].firstMatch
//        let lockTodayButton = app.buttons["Lock Today's Entry"].firstMatch
//        let confirmLockButton = app.buttons["Lock Entry"].firstMatch
//        
//        // 2. Perform actions to lock today's entry, completing the 3-day streak
//        XCTAssertTrue(entryTextField.waitForExistence(timeout: 2), "The entry text field should exist.")
//        entryTextField.tap()
//        entryTextField.typeText("This is the third day of my streak!")
//        
//        positiveButton.tap()
//        
//        lockTodayButton.tap()
//        
//        XCTAssertTrue(confirmLockButton.waitForExistence(timeout: 2), "The confirmation lock button should appear.")
//        confirmLockButton.tap()
//        
//        let streakAchievementText = app.staticTexts["streakCountText"]
//        XCTAssertTrue(streakAchievementText.waitForExistence(timeout: 2), "The 3-day streak achievement view should be displayed.")
//    }
//}
