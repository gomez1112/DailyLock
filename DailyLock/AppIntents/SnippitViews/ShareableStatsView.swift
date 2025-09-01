//
//  ShareableStatsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/31/25.
//


// ShareableStatsView.swift
import SwiftUI
import Charts

struct ShareableStatsView: View {
    let entries: [MomentumEntry]
    let dateRange: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var stats: JournalStatisticsSummary {
        StreakCalculator.journalStatistics(for: entries)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            headerSection
            
            // Main stats grid
            statsGrid
            
            // Mood distribution chart
            moodChart
            
            // Monthly activity chart
            monthlyChart
            
            // Footer
            footerSection
        }
        .frame(width: 800, height: 1000)
        .background(backgroundView)
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Your Journal Journey")
                .font(.system(size: 36, weight: .bold, design: .serif))
                .foregroundStyle(primaryColor)
            
            Text(dateRange)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            StatCard(
                icon: "flame.fill",
                title: "Current Streak",
                value: "\(stats.currentStreak)",
                subtitle: "days",
                color: .orange
            )
            
            StatCard(
                icon: "trophy.fill",
                title: "Longest Streak",
                value: "\(stats.longestStreak)",
                subtitle: "days",
                color: .yellow
            )
            
            StatCard(
                icon: "book.closed.fill",
                title: "Total Entries",
                value: "\(stats.totalEntries)",
                subtitle: "captured",
                color: .blue
            )
            
            StatCard(
                icon: "text.word.spacing",
                title: "Words Written",
                value: formatNumber(stats.totalWordsWritten),
                subtitle: "total",
                color: .purple
            )
        }
        .padding(.horizontal, 40)
    }
    
    private var moodChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundStyle(primaryColor)
            
            Chart(StatsCalculator.moodData(for: entries), id: \.sentiment) { item in
                SectorMark(
                    angle: .value("Count", item.count),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Mood", item.sentiment.rawValue))
                .cornerRadius(4)
            }
            .chartForegroundStyleScale([
                Sentiment.positive.rawValue: Color.green,
                Sentiment.indifferent.rawValue: Color.gray,
                Sentiment.negative.rawValue: Color.red
            ])
            .frame(height: 200)
            
            // Legend
            HStack(spacing: 20) {
                ForEach(Sentiment.allCases) { sentiment in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(sentiment.color)
                            .frame(width: 8, height: 8)
                        Text(sentiment.rawValue.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 40)
    }
    
    private var monthlyChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Monthly Activity")
                .font(.headline)
                .foregroundStyle(primaryColor)
            
            Chart(StatsCalculator.entriesByMonth(for: entries), id: \.month) { data in
                BarMark(
                    x: .value("Month", data.month, unit: .month),
                    y: .value("Entries", data.count)
                )
                .foregroundStyle(.accent.gradient)
                .cornerRadius(4)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) {
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            .frame(height: 200)
        }
        .padding(.horizontal, 40)
    }
    
    private var footerSection: some View {
        HStack {
            Image(systemName: "lock.fill")
                .font(.caption)
            Text("DailyLock")
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 30)
    }
    
    private var backgroundView: some View {
        ZStack {
            Image(colorScheme == .dark ? "defaultDarkPaper" : "defaultLightPaper")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.accent.opacity(0.02)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
    
    private var primaryColor: Color {
        colorScheme == .dark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor
    }
    
    private func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

// Reusable stat card component
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color.gradient)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}