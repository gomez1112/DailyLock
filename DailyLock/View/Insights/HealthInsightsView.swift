//
//  HealthInsightsView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//


import SwiftUI
import Charts
import HealthKit

// MARK: - Main Health Insights View
struct HealthInsightsView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    @State private var selectedTimeRange = TimeRange.week
    @State private var isLoading = false
    @State private var moodTrends: [(date: Date, averageValence: Double)] = []
    @State private var correlations: HealthCorrelations?
    
    enum TimeRange: String, CaseIterable {
        case week = "7 Days"
        case month = "30 Days"
        case quarter = "90 Days"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .quarter: return 90
            }
        }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                // Header with sync status
                headerSection
                
                // Time range selector
                timeRangeSelector
                
                if dependencies.healthStore.isAuthorized == true {
                    // Mood trends chart
                    MoodTrendChart(
                        trends: moodTrends,
                        timeRange: selectedTimeRange
                    )
                    .frame(height: 250)
                    .padding()
                    
                    // Summary cards
                    if let summary = dependencies.healthStore.moodSummary {
                        HealthSummaryCards(summary: summary)
                            .padding()
                    }
                    
                    // Mood distribution
                    MoodDistributionChart(
                        entries: dependencies.healthStore.recentMoodEntries
                    )
                    .frame(height: 200)
                    .padding()
                    
                    // Correlations section
                    if let correlations = correlations {
                        HealthCorrelationsView(correlations: correlations)
                            .padding()
                    }
                    
                    // Detailed entries
                    RecentHealthEntriesView(
                        entries: dependencies.healthStore.recentMoodEntries
                    )
                    .padding(.horizontal)
                    
                } else {
                    // Not authorized view
                    healthNotConnectedView
                }
            }
            .padding(.vertical)
        }
        .refreshable {
            await loadHealthData()
        }
        .task {
            await loadHealthData()
        }
        .onChange(of: selectedTimeRange) { _, _ in
            Task {
                await loadHealthData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Health Insights")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let lastSync = dependencies.healthStore.lastSyncDate {
                        Text("Last synced \(lastSync.formatted(.relative(presentation: .named)))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // Sync button
                Button {
                    Task {
                        await syncWithHealth()
                    }
                } label: {
                    Image(systemName: isLoading ? "arrow.triangle.2.circlepath" : "arrow.triangle.2.circlepath")
                        .font(.title2)
                        .foregroundStyle(.accent)
                        .symbolEffect(.rotate, value: isLoading)
                }
                .disabled(isLoading)
            }
            .padding(.horizontal)
            
            if dependencies.healthStore.isAuthorized == true {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text("Connected to Health")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
    
    private var timeRangeSelector: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var healthNotConnectedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Connect to Apple Health")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enable Health integration to see mood trends and wellness insights")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                Task {
                    _ = try? await dependencies.healthStore.requestAuthorization()
                }
            } label: {
                Label("Connect Health", systemImage: "heart.fill")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.vertical, 60)
    }
    
    // MARK: - Data Loading
    
    private func loadHealthData() async {
        isLoading = true
        
        // Load mood trends
        moodTrends = await dependencies.healthStore.calculateMoodTrends(days: selectedTimeRange.days)
        
        // Load recent data
        await dependencies.healthStore.loadRecentMoodData(days: selectedTimeRange.days)
        
        // Load correlations (if available)
        if #available(iOS 16.0, *) {
            correlations = await loadCorrelations()
        }
        
        isLoading = false
    }
    
    private func syncWithHealth() async {
        isLoading = true
        
        // Get all entries from the app
        do {
            let entries = try dependencies.dataService.fetchAllEntries()
            try await dependencies.healthStore.syncEntries(entries)
            dependencies.haptics.success()
        } catch {
            dependencies.errorState.show(error as? AppError ?? DatabaseError.loadFailed)
        }
        
        await loadHealthData()
        isLoading = false
    }
    
    @available(iOS 16.0, *)
    private func loadCorrelations() async -> HealthCorrelations {
        let sleepCorrelation = try? await dependencies.healthStore.getSleepMoodCorrelation()
        let mindfulnessCorrelation = try? await dependencies.healthStore.getMindfulnessMoodCorrelation()
        
        return HealthCorrelations(
            sleep: sleepCorrelation,
            mindfulness: mindfulnessCorrelation
        )
    }
}

// MARK: - Mood Trend Chart
struct MoodTrendChart: View {
    let trends: [(date: Date, averageValence: Double)]
    let timeRange: HealthInsightsView.TimeRange
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Trends")
                .font(.headline)
                .foregroundStyle(isDark ? .white : .black)
            
            if trends.isEmpty {
                ContentUnavailableView(
                    "No mood data",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Start tracking your mood to see trends")
                )
                .frame(height: 200)
            } else {
                Chart(trends, id: \.date) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Mood", item.averageValence)
                    )
                    .foregroundStyle(.accent.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("Mood", item.averageValence)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                moodColor(for: item.averageValence).opacity(0.3),
                                moodColor(for: item.averageValence).opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                    
                    PointMark(
                        x: .value("Date", item.date),
                        y: .value("Mood", item.averageValence)
                    )
                    .foregroundStyle(moodColor(for: item.averageValence))
                    .symbolSize(50)
                }
                .chartYScale(domain: -1...1)
                .chartYAxis {
                    AxisMarks(values: [-1, -0.5, 0, 0.5, 1]) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let val = value.as(Double.self) {
                                Text(moodLabel(for: val))
                                    .font(.caption)
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    }
                }
            }
        }
        .padding()
        .cardBackground()
    }
    
    private func moodColor(for valence: Double) -> Color {
        if valence > 0.3 { return .green }
        if valence < -0.3 { return .red }
        return .blue
    }
    
    private func moodLabel(for valence: Double) -> String {
        switch valence {
        case 0.5...1: return "😊"
        case 0...0.5: return "🙂"
        case -0.5...0: return "😐"
        case -1...(-0.5): return "😔"
        default: return ""
        }
    }
}

// MARK: - Health Summary Cards
struct HealthSummaryCards: View {
    let summary: HealthMoodSummary
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Average mood card
                SummaryCard(
                    title: "Average Mood",
                    value: moodEmoji(for: summary.averageValence),
                    subtitle: String(format: "%.1f", summary.averageValence),
                    color: moodColor(for: summary.averageValence)
                )
                
                // Trend card
                SummaryCard(
                    title: "Trend",
                    systemImage: summary.trend.icon,
                    subtitle: trendText,
                    color: summary.trend.color
                )
            }
            
            HStack(spacing: 16) {
                // Total entries card
                SummaryCard(
                    title: "Entries",
                    value: "\(summary.totalEntries)",
                    subtitle: "This period",
                    color: .purple
                )
                
                // Dominant mood card
                if let dominant = dominantMood {
                    SummaryCard(
                        title: "Most Common",
                        value: dominant.emoji,
                        subtitle: dominant.name,
                        color: dominant.color
                    )
                }
            }
        }
    }
    
    private var trendText: String {
        switch summary.trend {
        case .improving: return "Improving"
        case .stable: return "Stable"
        case .declining: return "Declining"
        }
    }
    
    private var dominantMood: (name: String, emoji: String, color: Color)? {
        guard let maxSentiment = summary.distribution.max(by: { $0.value < $1.value })?.key else {
            return nil
        }
        
        switch maxSentiment {
        case .positive:
            return ("Positive", "😊", .green)
        case .negative:
            return ("Negative", "😔", .red)
        case .indifferent:
            return ("Neutral", "😐", .blue)
        }
    }
    
    private func moodEmoji(for valence: Double) -> String {
        switch valence {
        case 0.5...1: return "😄"
        case 0.2...0.5: return "😊"
        case -0.2...0.2: return "😐"
        case -0.5...(-0.2): return "😔"
        case -1...(-0.5): return "😢"
        default: return "😐"
        }
    }
    
    private func moodColor(for valence: Double) -> Color {
        if valence > 0.2 { return .green }
        if valence < -0.2 { return .red }
        return .blue
    }
}

// MARK: - Summary Card Component
struct SummaryCard: View {
    let title: String
    var value: String? = nil
    var systemImage: String? = nil
    let subtitle: String
    let color: Color
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if let value = value {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            } else if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(.title)
                    .foregroundStyle(color)
            }
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cardBackground()
    }
}

// MARK: - Mood Distribution Chart
struct MoodDistributionChart: View {
    let entries: [HealthMoodEntry]
    @Environment(\.isDark) private var isDark
    
    private var distribution: [(sentiment: String, count: Int, color: Color)] {
        var counts: [Sentiment: Int] = [:]
        for entry in entries {
            counts[entry.sentiment, default: 0] += 1
        }
        
        return [
            ("Positive", counts[.positive] ?? 0, .green),
            ("Neutral", counts[.indifferent] ?? 0, .blue),
            ("Negative", counts[.negative] ?? 0, .red)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundStyle(isDark ? .white : .black)
            
            Chart(distribution, id: \.sentiment) { item in
                SectorMark(
                    angle: .value("Count", item.count),
                    innerRadius: .ratio(0.5),
                    outerRadius: .ratio(1.0)
                )
                .foregroundStyle(item.color)
                .opacity(0.8)
            }
            .frame(height: 150)
            
            HStack(spacing: 20) {
                ForEach(distribution, id: \.sentiment) { item in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 8, height: 8)
                        Text("\(item.sentiment): \(item.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .cardBackground()
    }
}

// MARK: - Health Correlations
struct HealthCorrelations {
    let sleep: Double?
    let mindfulness: Double?
}

struct HealthCorrelationsView: View {
    let correlations: HealthCorrelations
    @Environment(\.isDark) private var isDark
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wellness Correlations")
                .font(.headline)
                .foregroundStyle(isDark ? .white : .black)
            
            VStack(spacing: 12) {
                if let sleep = correlations.sleep {
                    CorrelationRow(
                        icon: "moon.fill",
                        title: "Sleep Quality",
                        correlation: sleep
                    )
                }
                
                if let mindfulness = correlations.mindfulness {
                    CorrelationRow(
                        icon: "brain",
                        title: "Mindfulness",
                        correlation: mindfulness
                    )
                }
            }
        }
        .padding()
        .cardBackground()
    }
}

struct CorrelationRow: View {
    let icon: String
    let title: String
    let correlation: Double
    
    private var correlationText: String {
        let strength: String
        switch abs(correlation) {
        case 0.7...1: strength = "Strong"
        case 0.4..<0.7: strength = "Moderate"
        case 0.2..<0.4: strength = "Weak"
        default: strength = "No"
        }
        
        let direction = correlation > 0 ? "positive" : "negative"
        return "\(strength) \(direction) correlation"
    }
    
    private var correlationColor: Color {
        if abs(correlation) < 0.2 { return .gray }
        return correlation > 0 ? .green : .red
    }
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.accent)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(correlationText)
                    .font(.caption)
                    .foregroundStyle(correlationColor)
            }
            
            Spacer()
            
            Text(String(format: "%.2f", correlation))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding()
        .cardBackground()
    }
}

// MARK: - Recent Health Entries
struct RecentHealthEntriesView: View {
    let entries: [HealthMoodEntry]
    @Environment(\.isDark) private var isDark
    @State private var expandedEntries: Set<UUID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Entries")
                .font(.headline)
                .foregroundStyle(isDark ? .white : .black)
            
            if entries.isEmpty {
                Text("No recent mood entries")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
            } else {
                VStack(spacing: 8) {
                    ForEach(entries.prefix(10)) { entry in
                        HealthEntryRow(
                            entry: entry,
                            isExpanded: expandedEntries.contains(entry.id)
                        ) {
                            withAnimation {
                                if expandedEntries.contains(entry.id) {
                                    expandedEntries.remove(entry.id)
                                } else {
                                    expandedEntries.insert(entry.id)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .cardBackground()
    }
}

struct HealthEntryRow: View {
    let entry: HealthMoodEntry
    let isExpanded: Bool
    let onTap: () -> Void
    
    private var moodEmoji: String {
        switch entry.sentiment {
        case .positive: return "😊"
        case .negative: return "😔"
        case .indifferent: return "😐"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(moodEmoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if let label = entry.dominantLabel {
                        Text(labelText(for: label))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Valence:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.2f", entry.valence))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    if !entry.associations.isEmpty {
                        HStack {
                            Text("Context:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(entry.associations.map { associationText(for: $0) }.joined(separator: ", "))
                                .font(.caption)
                        }
                    }
                }
                .padding(.leading, 40)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.secondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func labelText(for label: HKStateOfMind.Label) -> String {
        switch label {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .angry: return "Angry"
        case .anxious: return "Anxious"
        case .peaceful: return "Peaceful"
        case .excited: return "Excited"
        case .content: return "Content"
        case .stressed: return "Stressed"
        case .frustrated: return "Frustrated"
        case .lonely: return "Lonely"
        case .grateful: return "Grateful"
        case .hopeful: return "Hopeful"
        case .indifferent: return "Indifferent"
        case .confident: return "Confident"
        case .proud: return "Proud"
        case .scared: return "Scared"
        case .surprised: return "Surprised"
        case .annoyed: return "Annoyed"
        case .ashamed: return "Ashamed"
        case .disgusted: return "Disgusted"
        case .embarrassed: return "Embarrassed"
        case .guilty: return "Guilty"
        case .jealous: return "Jealous"
        case .disappointed: return "Disappointed"
            default: return "Unknown"
        }
    }
    
    private func associationText(for association: HKStateOfMind.Association) -> String {
        switch association {
        case .community: return "Community"
        case .currentEvents: return "Current Events"
        case .dating: return "Dating"
        case .education: return "Education"
        case .family: return "Family"
        case .fitness: return "Fitness"
        case .friends: return "Friends"
        case .health: return "Health"
        case .hobbies: return "Hobbies"
        case .identity: return "Identity"
        case .money: return "Money"
        case .partner: return "Partner"
        case .selfCare: return "Self Care"
        case .spirituality: return "Spirituality"
        case .tasks: return "Tasks"
        case .travel: return "Travel"
        case .weather: return "Weather"
        case .work: return "Work"
        @unknown default: return "Other"
        }
    }
}

#Preview(traits: .previewData) {
    HealthInsightsView()

}
