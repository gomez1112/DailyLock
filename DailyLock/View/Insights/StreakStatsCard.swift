//
//  StreakStatsCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//


import SwiftUI

struct StreakStatsCard: View {
    
    let entries: [MomentumEntry]
    
    private var currentStreak: Int {
        calculateCurrentStreak()
    }
    
    private var longestStreak: Int {
        calculateLongestStreak()
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Current Streak
            VStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(currentStreak)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                Text("Current Streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 80)
            
            // Longest Streak
            VStack(spacing: 12) {
                Image(systemName: "trophy.fill")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(longestStreak)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                
                Text("Best Streak")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .cardBackground()
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = entries
            .filter { $0.isLocked }
            .sorted { $0.date > $1.date }
        
        guard !sortedEntries.isEmpty else { return 0 }
        
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        // Check if today already has an entry
        let hasEntryToday = sortedEntries.contains { calendar.isDate($0.date, inSameDayAs: checkDate) }
        
        // If no entry today, start checking from yesterday
        if !hasEntryToday {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        // Count consecutive days
        for entry in sortedEntries {
            if calendar.isDate(entry.date, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if entry.date < checkDate {
                // Check if we skipped days
                let dayDifference = calendar.dateComponents([.day], from: entry.date, to: checkDate).day ?? 0
                if dayDifference > 1 {
                    break
                }
            }
        }
        
        return streak
    }
    
    private func calculateLongestStreak() -> Int {
        let calendar = Calendar.current
        let sortedEntries = entries
            .filter { $0.isLocked }
            .sorted { $0.date < $1.date } // Sort ascending for longest streak calculation
        
        guard !sortedEntries.isEmpty else { return 0 }
        
        var longestStreak = 1
        var currentStreakCount = 1
        
        for i in 1..<sortedEntries.count {
            let previousDate = calendar.startOfDay(for: sortedEntries[i-1].date)
            let currentDate = calendar.startOfDay(for: sortedEntries[i].date)
            let dayDifference = calendar.dateComponents([.day], from: previousDate, to: currentDate).day ?? 0
            
            if dayDifference == 1 {
                // Consecutive day
                currentStreakCount += 1
                longestStreak = max(longestStreak, currentStreakCount)
            } else if dayDifference > 1 {
                // Gap in dates, reset current streak
                currentStreakCount = 1
            }
            // If dayDifference == 0 (same day), we don't increment the streak
        }
        
        // Also check if current streak is the longest
        let currentStreak = calculateCurrentStreak()
        return max(longestStreak, currentStreak)
    }
}


#Preview {
    StreakStatsCard(entries: MomentumEntry.samples)
}
