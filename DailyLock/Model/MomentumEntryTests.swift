import Testing
@testable import DailyLock

@Suite("MomentumEntry Tests")
struct MomentumEntryTests {
    @Test("Default initialization produces today's date, empty text, .neutral sentiment, not locked")
    func testDefaultInitialization() async throws {
        let entry = MomentumEntry()
        let today = Calendar.current.startOfDay(for: Date())
        #expect(Calendar.current.isDate(entry.date, inSameDayAs: today))
        #expect(entry.text == "")
        #expect(entry.sentiment == .neutral)
        #expect(entry.lockedAt == nil)
        #expect(entry.isLocked == false)
        #expect(entry.wordCount == 0)
        #expect(entry.inkColor.starts(with: "#"))
        #expect(entry.topKeywords == nil)
    }

    @Test("Custom initialization populates properties correctly and computes word count")
    func testCustomInitialization() async throws {
        let dt = Date().addingTimeInterval(-86400)
        let text = "This is a test entry with seven words."
        let sentiment: Sentiment = .positive
        let lockDate = dt
        let entry = MomentumEntry(date: dt, text: text, sentiment: sentiment, lockedAt: lockDate)
        #expect(entry.text == text)
        #expect(entry.sentiment == .positive)
        #expect(entry.lockedAt != nil)
        #expect(entry.isLocked == true)
        #expect(entry.wordCount == 8) // 8 words
    }

    @Test("displayDate returns Today, Yesterday, or a formatted string as expected")
    func testDisplayDate() async throws {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let past = Calendar.current.date(byAdding: .day, value: -5, to: today)!
        let entryToday = MomentumEntry(date: today, text: "", sentiment: .neutral, lockedAt: nil)
        let entryYesterday = MomentumEntry(date: yesterday, text: "", sentiment: .neutral, lockedAt: nil)
        let entryPast = MomentumEntry(date: past, text: "", sentiment: .neutral, lockedAt: nil)
        #expect(entryToday.displayDate == "Today")
        #expect(entryYesterday.displayDate == "Yesterday")
        #expect(entryPast.displayDate != "Today")
        #expect(entryPast.displayDate != "Yesterday")
        // Could check for weekday substring, but allow any formatted string
    }

    @Test("Samples array has correct count and valid properties")
    func testSamples() async throws {
        let samples = MomentumEntry.samples
        #expect(samples.count == 11, "Should match hardcoded count")
        for entry in samples {
            #expect(!entry.text.isEmpty)
            #expect(entry.lockedAt != nil)
            #expect(entry.wordCount > 0)
        }
    }
}
