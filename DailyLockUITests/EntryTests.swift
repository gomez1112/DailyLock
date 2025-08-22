//
//  EntryTests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/27/25.
//

import XCTest

@MainActor
final class EntryUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [ "No data", "skipOnboarding"]
        app.launch()
    }
    
    
    func testCanWriteAnEntry() {
        let editor = app.textFields["entryTextView"]
        XCTAssertTrue(editor.waitForExistence(timeout: 2), "THe main entry text field should exist.")
        editor.tap()
        
        let testText = "Today is a great day to get to know everyone better."
        editor.typeText(testText)
        XCTAssertEqual(editor.value as? String, testText, "The text view should contain the text that was typed.")
    }
    
    func testCanWriteAnEntryAndPickEmotion() {
  
        let entryTextField = app.textFields["entryTextView"]
        XCTAssert(entryTextField.exists, "The main entry text field should exist.")
        entryTextField.tap()
        
        let entryText = "Today is a great day to get to know everyone better."
        entryTextField.typeText(entryText)
        
        let positiveButton = app.segmentedControls.buttons["Positive"].firstMatch
        XCTAssert(positiveButton.exists, "The 'Positive' emotion button should exist.")
        positiveButton.tap()
        
        // Assert that the emotion button is now selected
        XCTAssert(positiveButton.isSelected, "The 'Positive' button should be selected after tapping.")
    }
    
    func testEntryButtonWorksAndNavigateToToday() {
 
        app.buttons["Timeline"].firstMatch.tap()
        
        let writeEntryButton = app.buttons["Write First Entry"].firstMatch
        let todayTabButton = app.tabBars.buttons["Today"]
        
        XCTAssert(writeEntryButton.exists, "The 'Write First Entry' button should be visible on the timeline.")
        writeEntryButton.tap()
        
        // Assert that we have navigated back to the "Today" screen
        
        XCTAssert(todayTabButton.isSelected, "The 'Today' tab should be selected.")
        
    }
    
    func testCanOpenPaywallOnInsightsAndCloseIt() {
        
        app.buttons["Insights"].firstMatch.tap()
        
        let upgradeButton = app.buttons["upgradeButton"].firstMatch
        let closeButton = app.buttons["Close"].firstMatch
        
        XCTAssert(upgradeButton.exists, "The upgrade button should be visible on the Insights screen.")
        upgradeButton.tap()
        
        // Assert the paywall is shown by checking for its close button
    
        XCTAssert(closeButton.exists, "The paywall's close button should be visible.")
        closeButton.tap()
        
        // Assert the paywall is dismissed by checking that the close button is gone
        XCTAssertFalse(closeButton.exists, "The paywall should be dismissed.")
        XCTAssert(upgradeButton.exists, "Should be back on the Insights screen.")
        
    }
}
