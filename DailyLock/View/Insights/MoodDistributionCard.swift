//
//  MoodDistributionCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Charts
import SwiftUI

struct MoodDistributionCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let entries: [MomentumEntry]
    
    private var moodData: [(sentiment: Sentiment, count: Int)] {
        let grouped = Dictionary(grouping: entries.filter { $0.isLocked }) { $0.sentiment }
        return Sentiment.allCases.map { sentiment in
            (sentiment, grouped[sentiment]?.count ?? 0)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundStyle(colorScheme == .dark ? Color.darkInkColor : Color.lightInkColor)
            
            Chart(moodData, id: \.sentiment) { item in
                BarMark(
                    x: .value("Mood", item.sentiment.rawValue.capitalized),
                    y: .value("Count", item.count)
                )
                .foregroundStyle(by: .value("Mood", item.sentiment.rawValue))
                .cornerRadius(8)
            }
            .chartForegroundStyleScale([
                Sentiment.positive.rawValue: Color(hex: "FFD700"),
                Sentiment.neutral.rawValue: Color(hex: "C0C0C0"),
                Sentiment.negative.rawValue: Color(hex: "6495ED")
            ])
            .frame(height: 200)
            .padding(.top, 8)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
                .shadow(color: colorScheme == .dark ? Color.darkShadowColor : Color.lightShadowColor, radius: 10))
    }
}

#Preview(traits: .previewData) {
    MoodDistributionCard(entries: MomentumEntry.samples)
}
