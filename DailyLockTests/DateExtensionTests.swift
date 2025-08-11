import Testing
import Foundation

@Suite("Date Extension Tests")
struct DateExtensionTests {
    @Test("Creates a date with correct year, month, and day")
    func testDateFromComponents() async throws {
        let year = 2025
        let month = 7
        let day = 27
        let customDate = Date().date(year: year, month: month, day: day)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: customDate)
        #expect(components.year == year, "Year should match")
        #expect(components.month == month, "Month should match")
        #expect(components.day == day, "Day should match")
    }
    
    @Test("Default day is 1 when not specified")
    func testDefaultDayIsOne() async throws {
        let year = 2025
        let month = 7
        let customDate = Date().date(year: year, month: month)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: customDate)
        #expect(components.year == year, "Year should match")
        #expect(components.month == month, "Month should match")
        #expect(components.day == 1, "Default day should be 1")
    }
}
