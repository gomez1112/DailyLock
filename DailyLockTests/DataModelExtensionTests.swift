import Foundation
import SwiftData
import Testing
@testable import DailyLock


@MainActor
@Suite("DataModel Extension Logic")
struct DataModelExtensionTests {
    
    let model: DataService
    let todayVM: TodayViewModel
    let timelineVM: TimelineViewModel
    
    init() {
            let container = ModelContainerFactory.createPreviewContainer
            model = DataService(container: container)
        todayVM = TodayViewModel(dataService: model, haptics: HapticEngine(), syncedSetting: SyncedSetting())
        timelineVM = TimelineViewModel()
    }
    static func create(onDay offset: Int, lockedAt: Date? = Date()) -> MomentumEntry {
        let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
        return MomentumEntry(date: date, detail: "Test Entry", sentiment: .indifferent, lockedAt: lockedAt)
    }
    // Test a single-day streak from today.
    @Test("Current Streak: 1-Day Streak Today Only")
    func currentStreakTodayOnly() {
        let entries = [Self.create(onDay: 0)]
        let streakInfo = StreakCalculator.calculateStreak(from: entries)
        #expect(streakInfo.count == 1)
        #expect(streakInfo.gracePeriodUsed == false)
        #expect(streakInfo.isGracePeriodActiveNow == false)
    }
    
    // Test when there are no entries.
    @Test("Current Streak: No Entries")
    func currentStreak_NoEntries() {
        let entries: [MomentumEntry] = []
        let streakInfo = StreakCalculator.calculateStreak(from: entries)
        #expect(streakInfo.count == 0)
    }
    
    // Test when there are entries, but none are locked/completed.
    @Test("Current Streak: No Locked Entries")
    func currentStreak_NoLockedEntries() {
        let entries = [
            Self.create(onDay: 0, lockedAt: nil),
            Self.create(onDay: -1, lockedAt: nil)
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries)
        #expect(streakInfo.count == 0)
    }
    
    // Test a streak broken by a two-day gap.
    @Test("Current Streak: Broken Streak")
    func currentStreak_BrokenStreak() {
        let entries = [
            Self.create(onDay: 0),
            // Day -1 is missed
            // Day -2 is missed
            Self.create(onDay: -3)
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: true)
        #expect(streakInfo.count == 1, "Streak should be 1 as it was broken")
        #expect(streakInfo.gracePeriodUsed == false)
        #expect(streakInfo.isGracePeriodActiveNow == false)
    }
    
    // MARK: - Grace Period Tests (Current Streak)
    
    // Test when a grace period is actively saving a streak (missed yesterday, completed today).
    @Test("Grace Period: Streak Saved Today")
    func gracePeriod_SavedByCompletingToday() {
        let entries = [
            Self.create(onDay: 0),  // Today (saves the streak)
            // Yesterday is missed
            Self.create(onDay: -2), // 2 days ago
            Self.create(onDay: -3)  // 3 days ago
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: true)
        #expect(streakInfo.count == 3, "Expected streak of 3 (2 + 1 today), saved by grace")
        #expect(streakInfo.gracePeriodUsed == true)
        #expect(streakInfo.isGracePeriodActiveNow == false, "Not active now because today is complete")
    }
    
    // Test when the user is currently in a grace period window (missed yesterday, today not yet complete).
    @Test("Grace Period: Currently Active")
    func gracePeriod_IsActiveNow() {
        let entries = [
            // Today is NOT completed
            // Yesterday is missed
            Self.create(onDay: -2) // 2 days ago
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: true)
        #expect(streakInfo.count == 1, "Expected streak of 1, waiting on today")
        #expect(streakInfo.gracePeriodUsed == true)
        #expect(streakInfo.isGracePeriodActiveNow == true, "Should be in an active grace period")
    }
    
    // Test that a grace period is NOT used if the setting is disabled.
    @Test("Grace Period: Disabled")
    func gracePeriodDisabled() {
        let entries = [
            Self.create(onDay: 0),
            // Yesterday is missed
            Self.create(onDay: -2)
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: false)
        #expect(streakInfo.count == 1, "Streak should be 1 because grace period is off")
        #expect(streakInfo.gracePeriodUsed == false)
    }
    
    // Test that a grace period is not incorrectly reported for a non-existent streak.
    @Test("Grace Period: Not Used on Non-Existent Streak")
    func gracePeriodNotUsedOnNonExistentStreak() {
        let entries = [
            // Last entry was long ago
            Self.create(onDay: -5)
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: true)
        #expect(streakInfo.count == 0)
        #expect(streakInfo.gracePeriodUsed == false, "Grace period should not be 'used' if no streak was saved")
        #expect(streakInfo.isGracePeriodActiveNow == false)
    }
    
    // MARK: - calculateLongestStreak Tests
    
    // Test a simple continuous streak.
    @Test("Longest Streak: Single Continuous Streak")
    func longestStreakSingleContinuous() {
        let entries = [
            Self.create(onDay: -5),
            Self.create(onDay: -6),
            Self.create(onDay: -7),
            Self.create(onDay: -8)
        ]
        let longest = StreakCalculator.calculateLongestStreak(for: entries)
        #expect(longest == 4)
    }
    
    // Test identifying the longer of two separate streaks.
    @Test("Longest Streak: Longer of Two Streaks")
    func longestStreakLongerOfTwo() {
        let entries = [
            Self.create(onDay: -2), // Streak 1 (length 2)
            Self.create(onDay: -3),
            Self.create(onDay: -7), // Streak 2 (length 4)
            Self.create(onDay: -8),
            Self.create(onDay: -9),
            Self.create(onDay: -10)
        ]
        let longest = StreakCalculator.calculateLongestStreak(for: entries)
        #expect(longest == 4, "Expected the longest streak to be 4")
    }
    
    // Test a longest streak that was saved by a grace period.
    @Test("Longest Streak: Includes Grace Period")
    func longestStreakWithGracePeriod() {
        let entries = [
            Self.create(onDay: -5),
            Self.create(onDay: -6),
            // Day -7 is missed
            Self.create(onDay: -8),
            Self.create(onDay: -9)
        ]
        let longest = StreakCalculator.calculateLongestStreak(for: entries, allowGracePeriod: true)
        #expect(longest == 4, "Expected longest streak of 4, bridged by grace")
    }
    
    // Test that a streak breaks if a grace period is not allowed.
    @Test("Longest Streak: Broken Without Grace Period")
    func longestStreakBrokenWithoutGrace() {
        let entries = [
            Self.create(onDay: -5),
            Self.create(onDay: -6),
            // Day -7 is missed
            Self.create(onDay: -8),
            Self.create(onDay: -9)
        ]
        let longest = StreakCalculator.calculateLongestStreak(for: entries, allowGracePeriod: false)
        #expect(longest == 2, "Expected two separate streaks of 2, so longest is 2")
    }
    
    // Test that a streak breaks after a second grace period is needed.
    @Test("Longest Streak: Broken by Second Grace Attempt")
    func longestStreakBrokenBySecondGrace() {
        let entries = [
            Self.create(onDay: -5),
            // Day -6 is missed (uses grace)
            Self.create(onDay: -7),
            // Day -8 is missed (breaks streak)
            Self.create(onDay: -9)
        ]
        let longest = StreakCalculator.calculateLongestStreak(for: entries, allowGracePeriod: true)
        #expect(longest == 2, "Expected longest streak of 2, as second grace breaks it")
    }
    
    // MARK: - Look-Back Limit Tests
    
    @Test("Look-Back Limit: Current Streak")
    func lookBackCurrentStreak() {
        let entries = [
            Self.create(onDay: 0),
            Self.create(onDay: -1),
            Self.create(onDay: -2), // This should be ignored by the limit
            Self.create(onDay: -3)  // This should be ignored by the limit
        ]
        // Limit to ~1.5 days of history
        let limit = TimeInterval.days(1)
        let streakInfo = StreakCalculator.calculateStreak(from: entries, lookBackLimit: limit)
        #expect(streakInfo.count == 2, "Streak should be 2 due to look-back limit")
    }
    
    @Test("Look-Back Limit: Longest Streak")
    func lookBackLongestStreak() {
        let entries = [
            Self.create(onDay: -1), // Part of recent streak
            Self.create(onDay: -2), // Part of recent streak
            Self.create(onDay: -10), // Old streak, should be ignored
            Self.create(onDay: -11),
            Self.create(onDay: -12)
        ]
        // Limit to ~5 days of history
        let limit = TimeInterval.days(5)
        let longest = StreakCalculator.calculateLongestStreak(for: entries, lookBackLimit: limit)
        #expect(longest == 2, "Longest streak should be 2 due to look-back limit ignoring the older streak")
    }
    // Test a simple, continuous streak ending today.
    @Test("Current Streak: 3-Day Streak Ending Today")
    func streak3DaysEndingToday() {
        // 3 consecutive days, with today
        let entries = Array(MomentumEntry.samples.suffix(3))
        let streakInfo = StreakCalculator.calculateStreak(from: entries)
        #expect(streakInfo.count == 3)
        #expect(streakInfo.gracePeriodUsed == false)
        #expect(streakInfo.isGracePeriodActiveNow == false)
    }
    // Test a streak that ended yesterday because today is not yet completed.
    @Test("Current Streak: 2-Day Streak Ending Yesterday")
    func currentStreak2DaysEndingYesterday() {
        let entries = [
            // Today is NOT completed
            Self.create(onDay: -1), // Yesterday
            Self.create(onDay: -2)  // 2 days ago
        ]
        let streakInfo = StreakCalculator.calculateStreak(from: entries)
        #expect(streakInfo.count == 2, "Expected a 2-day streak ending yesterday")
        #expect(streakInfo.gracePeriodUsed == false)
        #expect(streakInfo.isGracePeriodActiveNow == false)
    }
    @Test("calculateStreak returns correct grace period info")
    func calculateStreakWithGracePeriod() {
        // Create entries with a gap to test grace period
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        _ = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        
        let entries = [
            MomentumEntry(date: twoDaysAgo, detail: "Day 1", sentiment: .indifferent, lockedAt: twoDaysAgo),
            // yesterday is missing - this would be the grace period
            // today not completed yet
        ]
        
        let streakInfo = StreakCalculator.calculateStreak(from: entries, allowGracePeriod: true)
        #expect(streakInfo.count == 1)
        #expect(streakInfo.gracePeriodUsed == true)
        #expect(streakInfo.isGracePeriodActiveNow == true)
    }
    @Test("todayEntry finds today's entry")
    func testTodayEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        let entry = MomentumEntry(date: today, lockedAt: today)
        let entries = [entry]
        let found = model.todayEntry(for: entries)
        #expect(found === entry)
    }

    @Test("characterCount returns correct count")
    func testCharacterCount() {
        todayVM.currentDetail = "Hello, world!"
        #expect(todayVM.characterCount == 13)
    }

    @Test("progressToLimit caps at 1.0")
    func testProgressToLimit() {
        todayVM.currentDetail = String(repeating: "a", count: 200)
        #expect(todayVM.progressToLimit == 1.0)
    }

    @Test("progressColor returns correct style")
    func testProgressColor() {
        #expect(todayVM.progressColor(progress: 0.95, isDark: false) == .red)
        #expect(todayVM.progressColor(progress: 0.8, isDark: false) == .orange)
        #expect(todayVM.progressColor(progress: 0.5, isDark: false) == .lightLine)
        #expect(todayVM.progressColor(progress: 0.5, isDark: true) == .darkLine)
    }

    @Test("groupedEntries groups by month/year")
    func testGroupedEntries() {
        let calendar = Calendar.current
        let now = Date()
        let lastMonth = calendar.date(byAdding: .month, value: -1, to: now)!
        let entry1 = MomentumEntry(date: now, lockedAt: now)
        let entry2 = MomentumEntry(date: lastMonth, lockedAt: lastMonth)
        let groups = timelineVM.groupedEntries(for: [entry1, entry2])
        #expect(groups.count == 2)
    }

    @Test("moodData counts sentiments")
    func testMoodData() {
        let entries = [
            MomentumEntry(sentiment: .positive, lockedAt: Date()),
            MomentumEntry(sentiment: .negative, lockedAt: Date()),
            MomentumEntry(sentiment: .positive, lockedAt: Date())
        ]
        let data = StatsCalculator.moodData(for: entries)
        let positive = data.first { $0.sentiment == .positive }!
        let negative = data.first { $0.sentiment == .negative }!
        #expect(positive.count == 2)
        #expect(negative.count == 1)
    }

    @Test("calculateLongestStreak finds max streak")
    func testCalculateLongestStreak() {
        // 3-day streak, gap, then another 1-day streak
        let streak3 = Array(MomentumEntry.samples.suffix(3))
        let streak1 = Array(MomentumEntry.samples.prefix(2))
        let all = streak3 + streak1
        let longest = StreakCalculator.calculateLongestStreak(for: all)
        #expect(longest == 3)
    }

    @Test("entriesByMonth counts entries per month in current year")
    func testEntriesByMonth() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())

        // Two entries in January, one entry in May
        let jan1 = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 5))!
        let jan2 = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 21))!
        let may = calendar.date(from: DateComponents(year: currentYear, month: 5, day: 10))!
        let entry1 = MomentumEntry(date: jan1, lockedAt: jan1)
        let entry2 = MomentumEntry(date: jan2, lockedAt: jan2)
        let entry3 = MomentumEntry(date: may, lockedAt: may)
        let entries = [entry1, entry2, entry3]

        let results = StatsCalculator.entriesByMonth(for: entries)
        // Should be 12 results (months), count for Jan = 2, May = 1, rest = 0
        #expect(results.count == 12)
        let janResult = results.first { calendar.component(.month, from: $0.month) == 1 }!
        let mayResult = results.first { calendar.component(.month, from: $0.month) == 5 }!
        #expect(janResult.count == 2, "January should have 2 entries")
        #expect(mayResult.count == 1, "May should have 1 entry")
        // All other months should have count 0
        for result in results where ![1,5].contains(calendar.component(.month, from: result.month)) {
            #expect(result.count == 0, "Other months should have 0 entries")
        }
    }
}

extension TimeInterval {
    static func days(_ value: Double) -> TimeInterval {
        return value * 24 * 60 * 60
    }
}
