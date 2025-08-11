//
//  YearlyStatsCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/3/25.
//


import Charts
import SwiftUI

struct YearlyStatsCard: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    
    let entries: [MomentumEntry]
    
    private var yearlyData: [(month: Date, count: Int)] {
        StatsCalculator.entriesByMonth(for: entries)
    }
    
    private var totalEntriesThisYear: Int {
        yearlyData.reduce(0) { $0 + $1.count }
    }
    var body: some View {
        HStack {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Stats")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("yearlyStatsHeader")
                
                Text(totalEntriesThisYear.formatted())
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                    .contentTransition(.numericText())
                    .accessibilityIdentifier("yearlyEntryCount")
                
                Text("Entries")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                    .accessibilityIdentifier("entriesLabel")
                Text("This Year")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier("thisYearLabel")
                Spacer()
            }
            // Monthly Chart
                monthlyChartView
        }
        .padding(deviceStatus == .compact ? 20 : 24)
        .cardBackground(cornerRadius: AppLayout.radiusLarge, shadowRadius: DesignSystem.Shadow.shadowSmall)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("yearlyStatsCard")
    }
    
    private var monthlyChartView: some View {
        Chart(yearlyData, id: \.month) { data in
            BarMark(
                x: .value("Month", data.month, unit: .month),
                y: .value("Count", data.count)
            )
            .cornerRadius(4)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .month, count: 1)) {
                AxisValueLabel(format: .dateTime.month(.narrow))
            }
            
        }
        .chartYAxis {
            AxisMarks(values: .stride(by: 5))
        }
        .frame(height: deviceStatus == .compact ? 80 : 100)
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
        .accessibilityIdentifier("monthlyEntriesChart")
    }
}
