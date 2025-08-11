
import Foundation
import Testing
@testable import DailyLock


@MainActor
@Suite("Tabs enum parameterized tests")
struct TabsTests {
    let cases: [(tab: Tabs, rawValue: String, title: String, icon: String, customizationID: String)] = [
        (.today, "today", "Today", "pencil.tip", "com.transfinite.dailylock.today"),
        (.timeline, "timeline", "Timeline", "calendar", "com.transfinite.dailylock.timeline"),
        (.insights, "insights", "Insights", "chart.line.uptrend.xyaxis", "com.transfinite.dailylock.insights"),
        (.settings, "settings", "Settings", "gear", "com.transfinite.dailylock.settings"),
        (.search, "search", "Search", "magnifyingglass", "com.transfinite.dailylock.search")
    ]

    @Test("Tabs properties match expected values")
    func testTabsProperties() async throws {
        for (tab, expectedRawValue, expectedTitle, expectedIcon, expectedCustomizationID) in cases {
            #expect(tab.rawValue == expectedRawValue, "Raw value for \(tab) should be \(expectedRawValue)")
            #expect(tab.id == tab, "ID for \(tab) should be itself")
            #expect(tab.title == expectedTitle, "Title for \(tab) should be \(expectedTitle)")
            #expect(tab.icon == expectedIcon, "Icon for \(tab) should be \(expectedIcon)")
            #expect(tab.customizationID == expectedCustomizationID, "Customization ID for \(tab) should be \(expectedCustomizationID)")
        }
    }
    @Test("Tab titles are correct", arguments: [
        (Tabs.today, "Today"),
        (Tabs.insights, "Insights"),
        (Tabs.timeline, "Timeline"),
        (Tabs.settings, "Settings"),
        (Tabs.search, "Search")
    ])
    
    func testTabTitles(tab: Tabs, expectedTitle: String) async throws {
        #expect(tab.title == expectedTitle)
    }
    
    @Test("Tabs conform to CaseIterable and Codable")
    func testCaseIterableAndCodable() async throws {
        // CaseIterable
        #expect(Tabs.allCases.count == 5)
        // Codable round-trip
        let encoded = try JSONEncoder().encode(Tabs.today)
        let decoded = try JSONDecoder().decode(Tabs.self, from: encoded)
        #expect(decoded == .today)
    }
}
