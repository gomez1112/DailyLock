//
//  SupportGoal.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import SwiftData
import SwiftUI

struct SupportGoal: View {
    @Environment(\.deviceStatus) private var deviceStatus
    @Environment(\.isDark) private var isDark
    
    @Query(sort: \TipRecord.date, order: .reverse) private var allTips: [TipRecord]
    
    private var currentMonthTips: [TipRecord] {
        allTips.filter { $0.isFromCurrentMonth }
    }
    
    private var currentMonthTotal: Decimal {
        currentMonthTips.reduce(0) { $0 + $1.amount }
    }
    private var monthlyGoalProgress: Double {
        min(Double(truncating: currentMonthTotal as NSNumber) / Double(truncating: Feature.Paywall.Tips.monthlyGoalAmount as NSNumber), 1.0)
    }
    private var remainingAmount: Decimal {
        max(Decimal(Feature.Paywall.Tips.monthlyGoalAmount) - currentMonthTotal, 0)
    }
    
    private var coffeesRemaining: Int {
        // Assuming average tip is $3 (small coffee)
        Int(ceil(Double(truncating: remainingAmount as NSNumber) / 3.0))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .font(.body)
                    .foregroundStyle(.accent)
                Text("Monthly Goal")
                    .font(.subheadline.bold())
                Spacer()
                Text("\(Int(monthlyGoalProgress * 100))%")
                    .font(.caption.bold())
                    .foregroundStyle(.accent)
                    .contentTransition(.numericText())
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: monthlyGoalProgress >= 1.0
                                ? [Color.green, Color.green.opacity(0.8)]
                                : [Color.accent, Color.accent.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * monthlyGoalProgress, height: 12)
                        .animation(.spring(response: 1, dampingFraction: 0.8), value: monthlyGoalProgress)
                    
                    // Coffee cups markers
                    HStack(spacing: 0) {
                        ForEach(0..<5) { index in
                            let threshold = Double(index + 1) / 5.0
                            Image(systemName: monthlyGoalProgress >= threshold ? "cup.and.saucer.fill" : "cup.and.saucer")
                                .font(.caption2)
                                .foregroundStyle(monthlyGoalProgress >= threshold ? .white : .secondary)
                                .frame(width: geometry.size.width / 5)
                        }
                    }
                }
            }
            .frame(height: 12)
            
            if monthlyGoalProgress >= 1.0 {
                Text("🎉 Goal reached! Thank you amazing supporters!")
                    .font(.caption)
                    .foregroundStyle(.green)
            } else {
                Text("\(coffeesRemaining) more coffee\(coffeesRemaining == 1 ? "" : "s") to reach this month's server costs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Show recent supporters if any
            if !currentMonthTips.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(.red)
                    Text("\(currentMonthTips.count) supporter\(currentMonthTips.count == 1 ? "" : "s") this month")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isDark ? ColorPalette.darkCardBackground.opacity(0.5) : ColorPalette.lightCardBackground.opacity(0.5))
        )
        .accessibilityIdentifier("supportGoal")
        
    }
}

#Preview {
    SupportGoal()
}
