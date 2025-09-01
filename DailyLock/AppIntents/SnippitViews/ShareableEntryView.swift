//
//  ShareableEntryView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/31/25.
//

import SwiftUI

struct ShareableEntryView: View {
    let entry: MomentumEntry
    let includeStats: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with date
            headerSection
            
            // Main content
            contentSection
            
            // Footer with metadata
            footerSection
            
            if includeStats {
                statsSection
            }
        }
        .frame(width: 600, height: includeStats ? 900 : 700)
        .background(backgroundGradient)
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(entry.date.formatted(.dateTime.weekday(.wide)))
                .font(.custom("Snell Roundhand", size: 28))
                .foregroundStyle(inkColor)
            
            Text(entry.date.formatted(.dateTime.month(.wide).day().year()))
                .font(.caption)
                .tracking(2)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
    }
    
    private var contentSection: some View {
        VStack(spacing: 24) {
            if !entry.title.isEmpty {
                Text(entry.title)
                    .font(.custom("Georgia", size: 32))
                    .fontWeight(.bold)
                    .foregroundStyle(inkColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Text(entry.detail)
                .font(.custom("Georgia", size: 20))
                .foregroundStyle(inkColor.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .padding(.horizontal, 60)
                .frame(maxHeight: 300)
            
            // Sentiment indicator
            HStack(spacing: 12) {
                Image(systemName: entry.sentiment.symbol)
                    .font(.title2)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: entry.sentiment.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text(entry.sentiment.rawValue.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 30)
    }
    
    private var footerSection: some View {
        HStack {
            // Word count
            Label("\(entry.wordCount) words", systemImage: "text.word.spacing")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // App branding
            Label("DailyLock", systemImage: "lock.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, 60)
            
            HStack(spacing: 40) {
                StatBadge(
                    icon: "flame.fill",
                    value: "\(calculateCurrentStreak())",
                    label: "Day Streak"
                )
                
                StatBadge(
                    icon: "book.closed",
                    value: "\(calculateTotalEntries())",
                    label: "Total Entries"
                )
                
                StatBadge(
                    icon: "heart.fill",
                    value: "\(entry.sentiment.rawValue.capitalized)",
                    label: "Mood"
                )
            }
            .padding(.bottom, 20)
        }
    }
    
    private var backgroundGradient: some View {
        ZStack {
            // Paper texture background
            Image(colorScheme == .dark ? "defaultDarkPaper" : "defaultLightPaper")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            // Subtle gradient overlay
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var inkColor: Color {
        colorScheme == .dark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor
    }
    
    // Helper methods (would fetch from your data service)
    private func calculateCurrentStreak() -> Int {
        // Implementation would use your StreakCalculator
        return 7
    }
    
    private func calculateTotalEntries() -> Int {
        // Implementation would fetch from data service
        return 42
    }
    
    private struct StatBadge: View {
        let icon: String
        let value: String
        let label: String
        
        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.accent)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
