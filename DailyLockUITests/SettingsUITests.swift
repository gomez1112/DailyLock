//
//  SettingsUITests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/29/25.
//

import Foundation
import StoreKitTest
import XCTest

@MainActor
final class SettingsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        let session = try SKTestSession(configurationFileNamed: "Configuration")
        session.disableDialogs = true          // no system alerts during tests
        session.clearTransactions()
        
        app = XCUIApplication()
        app.launchArguments = [ "enable-testing", "skipOnboarding"]
        app.launch()
    }
    
    func testTapAndDismissUpgrade() {
        let settingsButton = app.buttons["Settings"]
        let upgradeButton = app.staticTexts["Upgrade to DailyLock+"]
        let closeButton = app.buttons["Close"]
        
        
        
        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
        settingsButton.tap()
        XCTAssert(upgradeButton.isHittable, "The 'Upgrade to DailyLock+' button should be visible and hittable.")
        upgradeButton.tap()
        XCTAssert(closeButton.isHittable, "The 'Close' button should be visible and hittable.")
        closeButton.tap()
        
    }

    func testCancelNotification() {
        let settingsButton = app.buttons["Settings"]
        let toggle = app.switches["0"].firstMatch
        
        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
        settingsButton.tap()
        
        XCTAssert(toggle.isHittable, "The 'toggle' should be visible and hittable.")
        toggle.tap()
    }
    
    func testTapAndDismissTips() {
        let settingsButton = app.buttons["Settings"]
        
        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
        settingsButton.tap()
    }
//    func testSupport() {
//        let settingsButton = app.buttons["Settings"]
//
//        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
//        settingsButton.tap()
//    }
    
    func testPolicies() {
        let settingsButton = app.buttons["Settings"]
        
        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
        settingsButton.tap()
        
    }
    
    func testAboutSection() {

        let settingsButton = app.buttons["Settings"]
        let versionButton = app.staticTexts["Version"]
        let restoreButton = app.staticTexts["Restore Purchases"]
        
        XCTAssert(settingsButton.isHittable, "The 'Settings' tabBar should be visible and hittable.")
        settingsButton.tap()
        
        app.collectionViews.firstMatch.swipeUp()
        
        XCTAssert(versionButton.isHittable, "The 'Version' button should be visible and hittable.")
        
        XCTAssert(restoreButton.isHittable, "The 'Restore' button should be visible and hittable.")
    }
    override func tearDownWithError() throws {
        app.terminate()        // guarantee the next test gets a new process
        app = nil
    }
}
