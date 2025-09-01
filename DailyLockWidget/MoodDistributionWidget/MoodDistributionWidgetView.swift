//
//  MoodDistributionWidgetView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/30/25.
//

import SwiftUI
import WidgetKit
import Charts

struct MoodDistributionWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme
    let entry: MoodDistributionEntry
    
    var body: some View {
        content
            .padding(paddingForFamily)
    }
    
    @ViewBuilder
    private var content: some View {
        if entry.total == 0 {
            emptyState
        } else {
            switch family {
            case .systemSmall:
                smallLayout
            case .systemMedium:
                mediumLayout
            case .systemLarge, .systemExtraLarge:
                largeLayout
            default:
                mediumLayout
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .strokeBorder(trackColor, lineWidth: 10)
                    .frame(width: 56, height: 56)
                Image(systemName: "chart.donut")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            Text("Keep Writing")
                .font(.headline)
                .fontWeight(.semibold)
            Text("Add your first entry to see mood insights.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue("No data yet")
    }
    
    // MARK: Layouts
    private var smallLayout: some View {
        VStack(spacing: 8) {
            donut
                .frame(height: 86)
            legendCompact
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue(accessibilitySummary)
    }
    
    private var mediumLayout: some View {
        HStack(spacing: 12) {
            donut
                .frame(width: 100, height: 100)
            VStack(alignment: .leading, spacing: 6) {
                header
                legendDetailed
                Spacer(minLength: 2)
                footer
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue(accessibilitySummary)
    }
    
    private var largeLayout: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            let interItemSpacing: CGFloat = 20
            let desired = computeDesiredDonutSize(width: w, height: h, interItemSpacing: interItemSpacing)
            
            VStack(alignment: .leading, spacing: 10) {
                header
                HStack(alignment: .top, spacing: interItemSpacing) {
                    donut
                        .frame(width: desired, height: desired)
                        .layoutPriority(0) // donut yields space first
                    VStack(alignment: .leading, spacing: 10) {
                        legendGridLarge
                            .padding(.top, 2)
                        Divider().opacity(0.15)
                        secondaryMetrics
                        Spacer(minLength: 0)
                        footer
                            .padding(.top, 2)
                    }
                    .layoutPriority(1) // text wins space
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue(accessibilitySummary)
    }
    
    // MARK: Components
    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Mood Patterns")
                .font(.headline)
                .fontWeight(.semibold)
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private var footer: some View {
        Text("Tap to open insights")
            .font(.caption2)
            .foregroundStyle(.secondary)
    }
    
    private var legendCompact: some View {
        HStack(spacing: 8) {
            ForEach(nonZeroSentiments, id: \.self) { s in
                let count = entry.counts[s] ?? 0
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(color(for: s))
                    Text(shortLabel(for: s, count: count))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var legendDetailed: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(nonZeroSentiments, id: \.self) { s in
                let count = entry.counts[s] ?? 0
                let pct = percentage(for: s)
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(color(for: s))
                    Text("\(labelName(for: s)): \(count) • \(pct)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
    }
    
    // Adaptive grid for large/extraLarge: fills 1–2+ columns based on space
    private var legendGridLarge: some View {
        let items = nonZeroSentiments
        let columns = [
            GridItem(.adaptive(minimum: 160), alignment: .leading)
        ]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { s in
                let count = entry.counts[s] ?? 0
                let pct = percentage(for: s)
                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(color(for: s))
                    Text("\(labelName(for: s)): \(count) • \(pct)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .accessibilityLabel("Mood breakdown")
    }
    
    // Secondary metrics for large/extraLarge
    private var secondaryMetrics: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let top = topSentiment {
                HStack(spacing: 8) {
                    Image(systemName: top.symbol)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(color(for: top))
                    Text("Top mood: \(labelName(for: top))")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }
                .accessibilityLabel("Top mood \(labelName(for: top))")
            }
            
            HStack(spacing: 8) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(color(for: .positive))
                Text("Positive ratio: \(positiveRatioText)")
                    .font(.footnote)
                    .foregroundStyle(.primary)
            }
            .accessibilityLabel("Positive ratio \(positiveRatioText)")
        }
        .padding(.top, 2)
    }
    
    // MARK: Donut (Swift Charts)
    private var donut: some View {
        GeometryReader { proxy in
            ZStack {
                // Soft track ring for remaining space and to anchor the chart visually
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(trackColor, style: StrokeStyle(lineWidth: trackWidth(for: proxy), lineCap: .round))
                    .padding(trackPadding(for: proxy))
                
                chartsDonut()
                    .accessibilityHidden(true)
                
                // Center label
                VStack(spacing: 0) {
                    Text("\(entry.total)")
                        .font(centerNumberFont)
                        .fontWeight(.bold)
                    Text("entries")
                        .font(centerCaptionFont)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private func chartsDonut() -> some View {
        let data = donutData
        return Chart(data) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(innerRatio),
                angularInset: 1.2
            )
            .foregroundStyle(by: .value("Sentiment", item.sentiment.rawValue))
            .cornerRadius(1.5)
        }
        .chartLegend(.hidden)
        .chartForegroundStyleScale([
            Sentiment.positive.rawValue: color(for: .positive),
            Sentiment.indifferent.rawValue: color(for: .indifferent),
            Sentiment.negative.rawValue: color(for: .negative)
        ])
        .chartBackground { _ in
            // Subtle inner highlight to crisp up the donut edge
            Circle()
                .inset(by: 1)
                .stroke(.white.opacity(colorScheme == .dark ? 0.06 : 0.12), lineWidth: 1)
        }
    }
    
    // MARK: Helpers
    private var paddingForFamily: CGFloat {
        switch family {
        case .systemSmall: 12
        case .systemMedium: 16
        default: 20
        }
    }

    private var subtitle: String {
        switch entry.configuration.range {
        case .last7Days: "Last 7 days"
        case .last30Days: "Last 30 days"
        case .allTime: "All time"
        }
    }
    
    private var nonZeroSentiments: [Sentiment] {
        Sentiment.allCases.filter { (entry.counts[$0] ?? 0) > 0 }
    }
    
    // Inner radius ratio for Charts donut thickness; tuned per family for balance
    private var innerRatio: CGFloat {
        switch family {
        case .systemSmall: 0.60
        case .systemMedium: 0.64
        default: 0.66
        }
    }
    
    private func trackWidth(for proxy: GeometryProxy) -> CGFloat {
        // Match the donut “thickness” visually
        let minSide = min(proxy.size.width, proxy.size.height)
        return max(10, minSide * (1 - innerRatio) * 0.8)
    }
    
    private func trackPadding(for proxy: GeometryProxy) -> CGFloat {
        // Keep the track just outside the chart’s inner radius
        let minSide = min(proxy.size.width, proxy.size.height)
        return max(6, minSide * 0.08)
    }
    
    private var trackColor: Color {
        colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.06)
    }
    
    private func color(for sentiment: Sentiment) -> Color {
        // Ensure “indifferent” has enough contrast in dark mode
        if sentiment == .indifferent, colorScheme == .dark {
            return sentiment.color.opacity(0.9)
        }
        return sentiment.color
    }
    
    private func shortLabel(for s: Sentiment, count: Int) -> String {
        switch s {
        case .positive: return "Pos \(count)"
        case .indifferent: return "Ind \(count)"
        case .negative: return "Neg \(count)"
        }
    }
    
    private func labelName(for s: Sentiment) -> String {
        switch s {
        case .positive: return "Positive"
        case .indifferent: return "Indifferent"
        case .negative: return "Negative"
        }
    }
    
    private func percentage(for s: Sentiment) -> String {
        let count = entry.counts[s] ?? 0
        guard entry.total > 0 else { return "0%" }
        let pct = Double(count) / Double(entry.total)
        let value = Int(round(pct * 100))
        return "\(value)%"
    }
    
    private var positiveRatioText: String {
        guard entry.total > 0 else { return "0%" }
        let pos = Double(entry.counts[.positive] ?? 0)
        let pct = Int(round((pos / Double(entry.total)) * 100))
        return "\(pct)%"
    }
    
    private var topSentiment: Sentiment? {
        let pairs = entry.counts.filter { $0.value > 0 }
        guard let top = pairs.max(by: { $0.value < $1.value }) else { return nil }
        return top.key
    }
    
    private var accessibilitySummary: String {
        let p = entry.counts[.positive] ?? 0
        let i = entry.counts[.indifferent] ?? 0
        let n = entry.counts[.negative] ?? 0
        return "Positive \(p), Indifferent \(i), Negative \(n). Total \(entry.total) entries."
    }
    
    // Data model for Charts donut
    private struct DonutItem: Identifiable {
        let sentiment: Sentiment
        let count: Int
        var id: Sentiment { sentiment }
    }
    
    private var donutData: [DonutItem] {
        Sentiment.allCases.compactMap { s in
            let c = entry.counts[s] ?? 0
            return c > 0 ? DonutItem(sentiment: s, count: c) : nil
        }
    }
    
    // Center label sizing
    private var centerNumberFont: Font {
        switch family {
        case .systemSmall: .system(size: 18)
        case .systemMedium: .system(size: 20)
        default: .system(size: 30)
        }
    }
    
    private var centerCaptionFont: Font {
        switch family {
        case .systemSmall: .caption2
        default: .caption2
        }
    }
    
    // MARK: Layout helpers
    private func computeDesiredDonutSize(width w: CGFloat, height h: CGFloat, interItemSpacing: CGFloat) -> CGFloat {
        var desired = min(h - 28, w * 0.46)
        desired = max(desired, 140) // ensure presence
        
        // Guarantee the right column gets enough width; if not, shrink the donut.
        let minRightColumn: CGFloat = 230
        if w - desired - interItemSpacing < minRightColumn {
            desired = max(120, w - minRightColumn - interItemSpacing)
        }
        return desired
    }
}

