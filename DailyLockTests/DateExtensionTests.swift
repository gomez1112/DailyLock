import Testing
import Foundation
@testable import DailyLock

@Suite("Date Extension Tests")
struct DateExtensionTests {
    @Test("Creates a date with correct year, month, and day")
    func testDateFromComponents() async throws {
        let year = 2025
        let month = 7
        let day = 27
        let customDate = Date(year: year, month: month, day: day) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: customDate)
        #expect(components.year == year, "Year should match")
        #expect(components.month == month, "Month should match")
        #expect(components.day == day, "Day should match")
    }
    
    @Test("Default day is 1 when not specified")
    func testDefaultDayIsOne() async throws {
        let year = 2025
        let month = 7
        let customDate = Date(year: year, month: month) ?? Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: customDate)
        #expect(components.year == year, "Year should match")
        #expect(components.month == month, "Month should match")
        #expect(components.day == 1, "Default day should be 1")
    }
    
    @Test("currentYear returns correct string for known date")
    func testCurrentYear() async throws {
        #expect(Date.currentYear == "2025", "Year string should be '2025'")
    }

    @Test("Initializer returns nil for invalid date components")
    func testInvalidDateComponents() async throws {
        let invalidDate = Date(year: 2025, month: 13, day: 1)
        #expect(invalidDate == nil, "Month 13 should produce nil")
    }
}
