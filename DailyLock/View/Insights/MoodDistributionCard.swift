//
//  MoodDistributionCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Charts
import SwiftUI
struct MoodDistributionCard: View {

    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    
    let entries: [MomentumEntry]
    
    private var chartAccessibleValue: String {
        let moodData = StatsCalculator.moodData(for: entries)
        return moodData.map { "\($0.sentiment.rawValue.capitalized): \($0.count)" }.joined(separator: ", ")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: deviceStatus == .compact ? 12 : 16) {
            Text("Mood Distribution")
                .font(deviceStatus == .compact ? .subheadline : .headline)
                .fontWeight(.semibold)
                .foregroundStyle(isDark ? ColorPalette.darkInkColor : ColorPalette.lightInkColor)
                .accessibilityIdentifier("MoodDistributionCard.Title")
                .accessibilityLabel("Mood Distribution Title")
            
            Chart(StatsCalculator.moodData(for: entries), id: \.sentiment) { item in
                BarMark(
                    x: .value("Mood", item.sentiment.rawValue.capitalized),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(by: .value("Mood", item.sentiment.rawValue))
                .cornerRadius(6)
            }
            .chartForegroundStyleScale([
                Sentiment.positive.rawValue: Color(hex: "FFD700") ?? .black,
                Sentiment.indifferent.rawValue: Color(hex: "C0C0C0") ?? .black,
                Sentiment.negative.rawValue: Color(hex: "6495ED") ?? .black
            ])
            .frame(height: deviceStatus == .compact ? 140 : 180)
            .accessibilityElement()
            .accessibilityLabel("Mood Distribution Chart")
            .accessibilityValue(Text(chartAccessibleValue))
            .accessibilityIdentifier("MoodDistributionCard.Chart")
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.caption)
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisValueLabel()
                        .font(.caption)
                }
            }
        }
        .padding(deviceStatus == .compact ? 16 : 20)
        .cardBackground(cornerRadius: AppLayout.radiusMedium, shadowRadius: DesignSystem.Shadow.shadowSmall)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("MoodDistributionCard.Container")
    }
}

#Preview(traits: .previewData) {
    MoodDistributionCard(entries: MomentumEntry.samples)
}
