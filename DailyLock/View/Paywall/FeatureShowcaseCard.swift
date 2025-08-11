struct FeatureShowcaseCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let feature: PremiumFeature
    let isAnimated: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Visual representation
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.accent.opacity(0.1),
                                Color.accent.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 140)
                
                featureVisual
            }
            
            // Description
            VStack(spacing: 8) {
                Text(feature.rawValue)
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? AppColor.darkInkColor : AppColor.lightInkColor)
                
                Text(featureDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 30)
        .opacity(isAnimated ? 1 : 0)
        .scaleEffect(isAnimated ? 1 : 0.8)
    }
    
    @ViewBuilder
    private var featureVisual: some View {
        switch feature {
            case .unlimitedEntries:
                HStack(spacing: -20) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(colorScheme == .dark ? AppColor.darkCardBackground : AppColor.lightCardBackground)
                            .frame(width: 60, height: 80)
                            .shadow(radius: 4)
                            .rotationEffect(.degrees(Double(index - 1) * 10))
                            .scaleEffect(isAnimated ? 1 : 0.5)
                            .animation(
                                .spring(response: 0.5)
                                .delay(Double(index) * 0.1),
                                value: isAnimated
                            )
                    }
                }
                
            case .advancedInsights:
                ZStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Sentiment.allCases[index].gradient[0],
                                        Sentiment.allCases[index].gradient[1]
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .offset(
                                x: index == 0 ? -30 : (index == 1 ? 30 : 0),
                                y: index == 2 ? -20 : 10
                            )
                            .opacity(0.7)
                            .scaleEffect(isAnimated ? 1 : 0.5)
                            .animation(
                                .spring(response: 0.5)
                                .delay(Double(index) * 0.1),
                                value: isAnimated
                            )
                    }
                }
                
            case .aiSummaries:
                VStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [Color.accent.opacity(0.3), Color.accent.opacity(0.1)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: CGFloat.random(in: 80...120), height: 8)
                    }
                }
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundStyle(.accent)
                        .symbolEffect(.pulse, isActive: isAnimated)
                )
                
            case .yearbook:
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.accent.gradient)
                    .rotationEffect(.degrees(isAnimated ? 0 : -10))
                    .scaleEffect(isAnimated ? 1 : 0.5)
        }
    }
    
    private var featureDescription: String {
        switch feature {
            case .unlimitedEntries:
                return "Capture every thought, every moment, without limits"
            case .advancedInsights:
                return "Discover patterns in your emotional journey"
            case .aiSummaries:
                return "Weekly reflections that reveal your growth"
            case .yearbook:
                return "Beautiful collections of your year's best memories"
        }
    }
}