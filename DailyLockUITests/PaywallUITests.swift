//
//  PaywallUITests.swift
//  DailyLockUITests
//
//  Created by Gerard Gomez on 7/29/25.
//

import Foundation
import StoreKitTest
import XCTest

@MainActor
final class PaywallUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        let session = try SKTestSession(configurationFileNamed: "Configuration")
        session.disableDialogs = true          // no system alerts during tests
        session.clearTransactions()            // <—— wipes all previous buys
        app = XCUIApplication()
        app.launchArguments = [ "enable-testing", "skipOnboarding"]
        app.launch()
    }
    
    func testSubscriptionPlanExists() {
        let insightTabBar = app.buttons["Insights"]
        let annualButton = app.buttons.containing(.staticText, identifier: "DailyLock+ Annual").firstMatch
        let monthlyButton = app.buttons.staticTexts["DailyLock+ Monthly"].firstMatch
        let weeklyButton =  app.buttons.staticTexts["DailyLock+ Weekly"].firstMatch
        let closeButton = app.buttons["Close"]
        let upgradeButton = app.buttons["upgradeButton"].firstMatch
        
        XCTAssert(insightTabBar.isHittable, "The 'Insights' tabBar should be visible and hittable.")
        insightTabBar.tap()
        
        XCTAssert(upgradeButton.exists, "The 'Upgrade' button should be visible and hittable.")
        upgradeButton.tap()
    
        
        XCTAssert(annualButton.exists, "The 'Annual' button should exists.")
        XCTAssert(monthlyButton.exists, "The 'Monthly' button should exists.")
        XCTAssert(weeklyButton.exists, "The 'Weekly' button should exists.")
        closeButton.tap()
     


        

        
        
    }
    
    func testSubscribeButton() {

        let insightTabBar = app.buttons["Insights"]
        let upgradeButton = app.buttons["upgradeButton"].firstMatch
        
        XCTAssert(insightTabBar.isHittable, "The 'Insights' tabBar should be visible and hittable.")
        insightTabBar.tap()
        
        XCTAssert(upgradeButton.isHittable, "The 'Upgrade' button should be visible and hittable.")
        upgradeButton.tap()
    }
}
