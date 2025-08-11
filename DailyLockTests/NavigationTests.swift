//
//  NavigationTests.swift
//  DailyLockTests
//
//  Created by Gerard Gomez on 7/22/25.
//

import Testing
@testable import DailyLock

@MainActor
@Suite("Navigation Tests")
struct NavigationTests {
    let navigation = NavigationContext()
    
    @Test("NavigationContext default is dashboard")
    func testNavigationContextDefault() {
        #expect(navigation.selectedTab == .today)
    }
    
    @Test("NavigationContext navigate works")
    func testNavigationContextNavigate() {
        navigation.navigate(to: .insights)
        #expect(navigation.selectedTab == .insights)
    }
}
