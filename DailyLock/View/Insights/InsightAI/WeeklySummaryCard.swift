//
//  WeeklySummaryCard.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import FoundationModels
import SwiftData
import SwiftUI

struct WeeklySummaryCard: View {
    
    @Query private var entries: [MomentumEntry]
    
    @State var generator: InsightGenerator
    
    @State private var isFullSummaryOpen = false
    @State private var isGenerating = false
    @State private var sparkleAnimation = false
    @Environment(\.isDark) private var isDark
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(HapticEngine.self) private var haptics
    
    private let foundationModel = SystemLanguageModel.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let insight = generator.insight {
                // Header Section
                headerSection(insight: insight)
                
                // Divider
                Rectangle()
                    .fill(isDark ? AppColor.darkLineColor : AppColor.lightLineColor)
                    .frame(height: 1)
                    .padding(.vertical, deviceStatus == .compact ? 12 : 16)
                    .opacity(0.5)
                
                // Content Section
                VStack(alignment: .leading, spacing: deviceStatus == .compact ? 16 : 20) {
                    // Summary
                    summarySection(insight: insight)
                    
                    // Action Items
                    if isFullSummaryOpen, let actions = insight.actionItems, !actions.isEmpty {
                        actionItemsSection(actions: actions)
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                    
                    // Quote
                    if isFullSummaryOpen, let quote = insight.quote {
                        quoteSection(quote: quote)
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                    
                    // Expand/Collapse Button
                    expandButton
                }
            } else if isGenerating {
                loadingView
            } else {
                switch foundationModel.availability {
                    case .available:
                        GenerateWeeklyInsightView(generator: generator)
                    case .unavailable(.appleIntelligenceNotEnabled):
                        MessageView(message: "Insight is unavailable because Apple Intelligence has not been turned on.")
                    case .unavailable(.modelNotReady):
                        MessageView(message: "Insight is not ready yet. Please try again later.")
                    case .unavailable(.deviceNotEligible):
                        MessageView(message: "Your device is not eligble for Insight Generation. You would need to upgrade to a newer model or use a different device.")
                    default:
                        MessageView(message: "No Apple Intelligence is available")
                }
            }
        }
        .padding(deviceStatus == .compact ? 20 : 24)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.radiusXLarge)
                .fill(isDark ? AppColor.darkCardBackground : AppColor.lightCardBackground)
                .shadow(
                    color: isDark ? AppColor.darkShadowColor : AppColor.lightShadowColor,
                    radius: AppLayout.shadowMedium,
                    y: 4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppLayout.radiusXLarge)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("WeeklySummaryCard")
        .task {
            generator = InsightGenerator(entries: entries)
            generator.prewarm()
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFullSummaryOpen)
        .animation(.easeInOut, value: isGenerating)
    }
    
    // MARK: - Header Section
    private func headerSection(insight: WeeklyInsight.PartiallyGenerated) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Weekly AI Summary")
                        .font(deviceStatus == .compact ? .headline : .title3)
                        .fontWeight(.bold)
                        .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
                    
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundStyle(.accent.gradient)
                        .symbolEffect(.variableColor.iterative, options: .repeating, value: sparkleAnimation)
                }
                
                if let title = insight.title {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .contentTransition(.opacity)
                        .animation(.easeOut, value: insight.id)
                }
            }
            
            Spacer(minLength: 16)
            
            // Animated icon
            ZStack {
                Circle()
                    .fill(.accent.gradient.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "brain.filled.head.profile")
                    .font(.title3)
                    .foregroundStyle(.accent.gradient)
                    .scaleEffect(sparkleAnimation ? 1.1 : 1.0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                sparkleAnimation = true
            }
        }
    }
    
    // MARK: - Summary Section
    private func summarySection(insight: WeeklyInsight.PartiallyGenerated) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let summary = insight.summary {
                Text(summary)
                    .font(deviceStatus == .compact ? .subheadline : .body)
                    .foregroundStyle(isDark ? AppColor.darkInkColor.opacity(0.9) : AppColor.lightInkColor.opacity(0.9))
                    .lineLimit(isFullSummaryOpen ? nil : 3)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("WeeklySummaryText")
                    .contentTransition(.opacity)
                    .animation(.easeOut, value: generator.insight)
            }
        }
    }
    
    // MARK: - Action Items Section
    private func actionItemsSection(actions: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Suggestions", systemImage: "lightbulb.fill")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.accent)
                            .scaleEffect(isFullSummaryOpen ? 1 : 0)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.6)
                                .delay(Double(index) * 0.1),
                                value: isFullSummaryOpen
                            )
                        
                        Text(action)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .contentTransition(.opacity)
                            .animation(.easeOut, value: generator.insight)
                    }
                }
            }
            .padding(.leading, 4)
        }
    }
    
    // MARK: - Quote Section
    private func quoteSection(quote: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "quote.opening")
                .font(.title3)
                .foregroundStyle(.accent.opacity(0.3))
            
            Text(quote)
                .font(.callout)
                .italic()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .contentTransition(.opacity)
                .animation(.easeOut, value: generator.insight)
            
            Image(systemName: "quote.closing")
                .font(.title3)
                .foregroundStyle(.accent.opacity(0.3))
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: AppLayout.radiusMedium)
                .fill(isDark ? Color.white.opacity(0.03) : Color.black.opacity(0.03))
        )
    }
    
    // MARK: - Expand Button
    private var expandButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isFullSummaryOpen.toggle()
                haptics.tap()
            }
        } label: {
            HStack {
                Text(isFullSummaryOpen ? "Show Less" : "Read Full Summary")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Image(systemName: isFullSummaryOpen ? "chevron.up" : "chevron.down")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .rotationEffect(.degrees(isFullSummaryOpen ? 0 : 0))
            }
            .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Generating Insights...")
                        .font(.headline)
                        .foregroundStyle(isDark ? AppColor.darkInkColor : AppColor.lightInkColor)
                    
                    Text("Analyzing your week")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.8)
            }
            
            // Shimmer placeholders
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isDark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .frame(height: 16)
                        .placeholderShimmer()
                }
            }
        }
    }
}
