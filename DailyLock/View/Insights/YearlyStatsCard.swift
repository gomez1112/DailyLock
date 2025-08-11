import Charts
import SwiftUI

struct YearlyStatsCard: View {
    @Environment(DataModel.self) private var model
    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    
    let entries: [MomentumEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: deviceStatus == .compact ? 16 : 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Stats")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("yearlyStatsHeader")
                
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(currentYearEntryCount.formatted())
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
                        .contentTransition(.numericText())
                        .accessibilityIdentifier("yearlyEntryCount")
                    
                    Text("Entries")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
                        .accessibilityIdentifier("entriesLabel")
                    
                    Spacer()
                }
                
                Text("This Year")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("thisYearLabel")
            }
            
            // Monthly Chart
            VStack(alignment: .leading, spacing: 12) {
                Chart(monthlyData, id: \.month) { item in
                    BarMark(
                        x: .value("Month", item.month),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.accentColor.opacity(0.8),
                                Color.accentColor.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(4)
                    .opacity(item.count > 0 ? 1.0 : 0.3)
                }
                .frame(height: deviceStatus == .compact ? 80 : 100)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel() {
                            if let month = value.as(String.self) {
                                Text(month)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        AxisGridLine(stroke: .clear)
                        AxisTick(stroke: .clear)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { value in
                        AxisValueLabel() {
                            if let count = value.as(Int.self) {
                                Text(count.formatted())
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        AxisGridLine(
                            stroke: StrokeStyle(
                                lineWidth: 0.5,
                                dash: [2, 4]
                            )
                        )
                        .foregroundStyle(.secondary.opacity(0.3))
                        AxisTick(stroke: .clear)
                    }
                }
                .chartYScale(domain: 0...maxMonthlyCount)
                .chartPlotStyle { plotContent in
                    plotContent
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    isDark 
                                    ? Color.white.opacity(0.02)
                                    : Color.black.opacity(0.02)
                                )
                        )
                }
                .accessibilityElement()
                .accessibilityLabel("Monthly entries chart")
                .accessibilityValue(chartAccessibilityValue)
                .accessibilityIdentifier("monthlyEntriesChart")
            }
        }
        .padding(deviceStatus == .compact ? 20 : 24)
        .cardBackground(cornerRadius: AppLayout.radiusLarge, shadowRadius: AppLayout.shadowSmall)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("yearlyStatsCard")
    }
    
    // MARK: - Computed Properties
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    private var currentYearEntries: [MomentumEntry] {
        let calendar = Calendar.current
        return entries.filter { entry in
            calendar.component(.year, from: entry.date) == currentYear && entry.isLocked
        }
    }
    
    private var currentYearEntryCount: Int {
        currentYearEntries.count
    }
    
    private struct MonthlyData {
        let month: String
        let count: Int
        let monthNumber: Int
    }
    
    private var monthlyData: [MonthlyData] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        var monthCounts: [Int: Int] = [:]
        
        // Count entries by month
        for entry in currentYearEntries {
            let month = calendar.component(.month, from: entry.date)
            monthCounts[month, default: 0] += 1
        }
        
        // Create data for all 12 months
        return (1...12).map { monthNumber in
            let date = calendar.date(from: DateComponents(year: currentYear, month: monthNumber, day: 1)) ?? Date()
            let monthAbbr = formatter.string(from: date).prefix(1).uppercased()
            
            return MonthlyData(
                month: String(monthAbbr),
                count: monthCounts[monthNumber] ?? 0,
                monthNumber: monthNumber
            )
        }
    }
    
    private var maxMonthlyCount: Int {
        let maxCount = monthlyData.map(\.count).max() ?? 1
        // Ensure minimum scale of 10 to match the design
        return max(maxCount, 10)
    }
    
    private var chartAccessibilityValue: String {
        let nonZeroMonths = monthlyData.filter { $0.count > 0 }
        if nonZeroMonths.isEmpty {
            return "No entries this year"
        }
        
        let monthDescriptions = nonZeroMonths.map { "\($0.month): \($0.count)" }
        return monthDescriptions.joined(separator: ", ")
    }
}