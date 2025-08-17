import Foundation

/// Holds the results of a current streak calculation.
struct StreakInfo {
    /// The number of consecutive days in the current streak.
    let count: Int
    /// A flag indicating if a grace period was used to save this streak.
    let gracePeriodUsed: Bool
    /// A flag indicating if the user is currently in an active grace period window (missed yesterday, can complete today to save the streak).
    let isGracePeriodActiveNow: Bool
}

/// A utility to calculate current and longest streaks from a list of entries.
struct StreakCalculator {
    
    // MARK: - Private Helper
    
    /// Creates a filtered and normalized set of completed days from an array of entries.
    private static func getCompletedDays(from entries: [MomentumEntry], lookBackLimit: TimeInterval?) -> Set<Date> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        
        var completedDays = Set(
            entries
                .filter(\.isLocked)
                .map { calendar.startOfDay(for: $0.date) }
                .filter { $0 <= startOfToday } // prevent future days from skewing streaks
        )
        
        if let lookBackLimit = lookBackLimit {
            let cutoff = calendar.startOfDay(for: Date().addingTimeInterval(-lookBackLimit))
            completedDays = completedDays.filter { $0 >= cutoff }
        }
        return completedDays
    }

    
    // MARK: - Public API
    
    /// Calculates the user's current streak ending today.
    static func calculateStreak(from entries: [MomentumEntry],
                                allowGracePeriod: Bool = false,
                                lookBackLimit: TimeInterval? = nil) -> StreakInfo {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else {
            let todayCompleted = !entries.filter { $0.isLocked && calendar.isDateInToday($0.date) }.isEmpty
            let count = todayCompleted ? 1 : 0
            return StreakInfo(count: count, gracePeriodUsed: false, isGracePeriodActiveNow: false)
        }
        
        let completedDays = getCompletedDays(from: entries, lookBackLimit: lookBackLimit)
        
        guard !completedDays.isEmpty else {
            return StreakInfo(count: 0, gracePeriodUsed: false, isGracePeriodActiveNow: false)
        }
        
        var streak = 0
        var currentDay = today
        var graceUsed = false
        var lastDayWasMissed = false
        var gracedDay: Date? = nil
        
        let todayCompleted = completedDays.contains(today)
        
        if todayCompleted {
            streak = 1
            currentDay = yesterday
        } else {
            currentDay = yesterday
        }
        
        // Walk backwards from yesterday to calculate the streak.
        while true {
            if completedDays.contains(currentDay) {
                streak += 1
                lastDayWasMissed = false
            } else {
                if lastDayWasMissed {
                    // Two consecutive misses - streak breaks.
                    break
                } else if !graceUsed && allowGracePeriod {
                    // First miss - tentatively use grace period.
                    graceUsed = true
                    gracedDay = currentDay
                    lastDayWasMissed = true
                } else {
                    // Can't use grace (already used or not allowed).
                    break
                }
            }
            
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDay) else {
                break
            }
            currentDay = previousDay
        }
        
        // --- Final Correction Logic ---
        
        let finalGraceUsed: Bool = {
            guard graceUsed, let g = gracedDay,
                  let dayBeforeGraced = calendar.date(byAdding: .day, value: -1, to: g)
            else { return false }
            // A miss is “spent” only if it connects to an earlier written day.
            return completedDays.contains(dayBeforeGraced)
        }()
        
        // Determine if we're in a grace period *now*.
        let isGracePeriodActiveNow = finalGraceUsed && (gracedDay == yesterday) && !todayCompleted
        
        return StreakInfo(
            count: streak,
            gracePeriodUsed: finalGraceUsed,
            isGracePeriodActiveNow: isGracePeriodActiveNow
        )
    }
    
    // NOTE: `calculateLongestStreak` did not require changes.
    // It is included for completeness.
    static func calculateLongestStreak(for entries: [MomentumEntry],
                                       allowGracePeriod: Bool = false,
                                       lookBackLimit: TimeInterval? = nil) -> Int {
        let calendar = Calendar.current
        let completedDays = getCompletedDays(from: entries, lookBackLimit: lookBackLimit)
        
        guard !completedDays.isEmpty else { return 0 }
        
        let sortedDays = completedDays.sorted()
        var longestStreak = 0
        var currentStreak = 0
        
        if !sortedDays.isEmpty {
            longestStreak = 1
            currentStreak = 1
        }
        
        var lastProcessedDay = sortedDays[0]
        var graceUsedInCurrentStreak = false
        
        for i in 1..<sortedDays.count {
            let currentDay = sortedDays[i]
            let dayDiff = calendar.dateComponents([.day], from: lastProcessedDay, to: currentDay).day ?? 0
            
            if dayDiff == 1 {
                currentStreak += 1
            } else if dayDiff == 2 && allowGracePeriod && !graceUsedInCurrentStreak {
                currentStreak += 1
                graceUsedInCurrentStreak = true
            } else {
                currentStreak = 1
                graceUsedInCurrentStreak = false
            }
            
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
            
            lastProcessedDay = currentDay
        }
        
        return longestStreak
    }
}
