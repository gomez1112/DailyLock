import Testing
import Foundation

// Mock Sentiment enum
enum Sentiment: CaseIterable {
    case positive, neutral, negative
}

// Mock MomentumEntry to use in tests
final class MomentumEntry {
    var text: String
    var sentiment: Sentiment
    var date: Date
    var lockedAt: Date?
    var wordCount: Int
    var isLocked: Bool { lockedAt != nil }
    init(text: String = "", sentiment: Sentiment = .neutral, date: Date = Date(), lockedAt: Date? = nil, wordCount: Int = 0) {
        self.text = text
        self.sentiment = sentiment
        self.date = date
        self.lockedAt = lockedAt
        self.wordCount = wordCount
    }
}

// Mock HapticEngine
struct HapticEngine {
    func lock() {}
    func success() {}
}

// Mock DataModel for testability
@testable import DailyLock // comment this if actual import causes issues

func makeEntries(forDaysAgo days: [Int], sentiment: Sentiment = .neutral) -> [MomentumEntry] {
    let calendar = Calendar.current
    return days.map {
        let date = calendar.date(byAdding: .day, value: -$0, to: calendar.startOfDay(for: Date()))!
        return MomentumEntry(text: "Entry \($0)", sentiment: sentiment, date: date, lockedAt: date, wordCount: 5)
    }
}

@Suite("DataModel Extension Logic")
struct DataModelExtensionTests {
    @Test("calculateStreak returns correct value")
    func testCalculateStreak() async throws {
        let dataModel = DataModel(container: .init())
        // 3 consecutive days, with today
        let entries = makeEntries(forDaysAgo: [0, 1, 2])
        let streak = dataModel.calculateStreak(for: entries)
        #expect(streak == 3)
    }

    @Test("todayEntry finds today's entry")
    func testTodayEntry() async throws {
        let dataModel = DataModel(container: .init())
        let today = Calendar.current.startOfDay(for: Date())
        let entry = MomentumEntry(date: today, lockedAt: today)
        let entries = [entry]
        let found = dataModel.todayEntry(for: entries)
        #expect(found === entry)
    }

    @Test("characterCount returns correct count")
    func testCharacterCount() async throws {
        let dataModel = DataModel(container: .init())
        dataModel.currentText = "Hello, world!"
        #expect(dataModel.characterCount == 13)
    }

    @Test("progressToLimit caps at 1.0")
    func testProgressToLimit() async throws {
        let dataModel = DataModel(container: .init())
        dataModel.currentText = String(repeating: "a", count: 200)
        #expect(dataModel.progressToLimit == 1.0)
    }

    @Test("progressColor returns correct style")
    func testProgressColor() async throws {
        let dataModel = DataModel(container: .init())
        #expect(dataModel.progressColor(progress: 0.95, isDark: false) == .red)
        #expect(dataModel.progressColor(progress: 0.8, isDark: false) == .orange)
        #expect(dataModel.progressColor(progress: 0.5, isDark: false) == .lightLine)
        #expect(dataModel.progressColor(progress: 0.5, isDark: true) == .darkLine)
    }

    @Test("groupedEntries groups by month/year")
    func testGroupedEntries() async throws {
        let dataModel = DataModel(container: .init())
        let calendar = Calendar.current
        let now = Date()
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
        let entry1 = MomentumEntry(date: now, lockedAt: now)
        let entry2 = MomentumEntry(date: lastMonth, lockedAt: lastMonth)
        let groups = dataModel.groupedEntries(for: [entry1, entry2])
        #expect(groups.count == 2)
    }

    @Test("moodData counts sentiments")
    func testMoodData() async throws {
        let dataModel = DataModel(container: .init())
        let entries = [
            MomentumEntry(sentiment: .positive, lockedAt: Date()),
            MomentumEntry(sentiment: .negative, lockedAt: Date()),
            MomentumEntry(sentiment: .positive, lockedAt: Date())
        ]
        let data = dataModel.moodData(for: entries)
        let positive = data.first { $0.sentiment == .positive }!
        let negative = data.first { $0.sentiment == .negative }!
        #expect(positive.count == 2)
        #expect(negative.count == 1)
    }

    @Test("calculateLongestStreak finds max streak")
    func testCalculateLongestStreak() async throws {
        let dataModel = DataModel(container: .init())
        // 3-day streak, gap, then another 2-day streak
        let streak3 = makeEntries(forDaysAgo: [0, 1, 2])
        let streak2 = makeEntries(forDaysAgo: [5, 6])
        let all = streak3 + streak2
        let longest = dataModel.calculateLongestStreak(for: all)
        #expect(longest == 3)
    }
}
