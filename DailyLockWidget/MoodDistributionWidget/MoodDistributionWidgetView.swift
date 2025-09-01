struct MoodDistributionWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: MoodDistributionEntry
    
    var body: some View {
        ZStack {
            // Background adapting to light/dark automatically
            ContainerRelativeShape()
                .fill(Color(.systemBackground))
            
            content
                .padding(paddingForFamily)
        }
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
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.secondary)
            Text("Keep Writing")
                .font(.headline)
            Text("You need at least 1 entry to see insights")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: Layouts
    private var smallLayout: some View {
        VStack(spacing: 8) {
            donut
                .frame(height: 80)
            legendCompact
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue(accessibilitySummary)
    }
    
    private var mediumLayout: some View {
        HStack(spacing: 12) {
            donut
                .frame(width: 90, height: 90)
            VStack(alignment: .leading, spacing: 6) {
                header
                legendDetailed
                Spacer()
                footer
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mood distribution")
        .accessibilityValue(accessibilitySummary)
    }
    
    private var largeLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            HStack {
                donut
                    .frame(width: 120, height: 120)
                Spacer(minLength: 8)
                legendDetailed
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            footer
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
            ForEach(Sentiment.allCases, id: \.self) { s in
                if let count = entry.counts[s], count > 0 {
                    HStack(spacing: 4) {
                        Circle().fill(color(for: s)).frame(width: 6, height: 6)
                        Text(shortLabel(for: s, count: count))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    
    private var legendDetailed: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Sentiment.allCases, id: \.self) { s in
                let count = entry.counts[s] ?? 0
                HStack(spacing: 8) {
                    Circle().fill(color(for: s)).frame(width: 8, height: 8)
                    Text(label(for: s, count: count))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    private var donut: some View {
        let segments = donutSegments
        return ZStack {
            // Background ring
            Circle()
                .stroke(Color(.tertiarySystemFill), lineWidth: ringWidth)
            // Segments
            ForEach(segments.indices, id: \.self) { idx in
                let seg = segments[idx]
                Circle()
                    .trim(from: seg.start, to: seg.end)
                    .stroke(color(for: seg.sentiment), style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
            // Center label
            VStack(spacing: 0) {
                Text("\(entry.total)")
                    .font(.system(size: 20, weight: .bold))
                Text("entries")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityHidden(true)
    }
    
    // MARK: Helpers
    private var paddingForFamily: CGFloat {
        switch family {
        case .systemSmall: 12
        case .systemMedium: 16
        default: 16
        }
    }
    private var ringWidth: CGFloat {
        switch family {
        case .systemSmall: 10
        case .systemMedium: 12
        default: 14
        }
    }
    private var subtitle: String {
        switch entry.configuration.range {
        case .last7Days: "Last 7 days"
        case .last30Days: "Last 30 days"
        case .allTime: "All time"
        }
    }
    
    private func color(for sentiment: Sentiment) -> Color {
        // Reuse Sentiment’s own color mapping to avoid duplication with the app.
        sentiment.color
    }
    
    private func shortLabel(for s: Sentiment, count: Int) -> String {
        switch s {
        case .positive: return "Pos \(count)"
        case .indifferent: return "Ind \(count)"
        case .negative: return "Neg \(count)"
        }
    }
    
    private func label(for s: Sentiment, count: Int) -> String {
        let name: String = {
            switch s {
            case .positive: return "Positive"
            case .indifferent: return "Indifferent"
            case .negative: return "Negative"
            }
        }()
        return "\(name): \(count)"
    }
    
    private var accessibilitySummary: String {
        let p = entry.counts[.positive] ?? 0
        let i = entry.counts[.indifferent] ?? 0
        let n = entry.counts[.negative] ?? 0
        return "Positive \(p), Indifferent \(i), Negative \(n), total \(entry.total)"
    }
    
    private struct Segment {
        let sentiment: Sentiment
        let start: CGFloat
        let end: CGFloat
    }
    
    private var donutSegments: [Segment] {
        let total = max(entry.total, 1) // avoid division by zero
        var start: CGFloat = 0
        var segments: [Segment] = []
        for s in Sentiment.allCases {
            let count = entry.counts[s] ?? 0
            let frac = CGFloat(count) / CGFloat(total)
            let end = start + frac
            if frac > 0 {
                segments.append(Segment(sentiment: s, start: start, end: end))
            }
            start = end
        }
        return segments
    }
}