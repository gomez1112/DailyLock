//
//  PremiumFeature.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation

/// Represents the individual premium features available in the DailyLock app.
/// 
/// Each case corresponds to a specific premium benefit that enhances user experience,
/// such as removing entry limits or unlocking advanced analytics.
/// 
/// - `unlimitedEntries`: Allows users to create an unlimited number of daily entries.
/// - `advancedInsights`: Provides users with mood and keyword trend analytics.
/// - `yearlyStats`: Unlocks yearly statistics for deeper historical insights.
/// - `aiSummaries`: Delivers AI-generated weekly summaries of user activity.
/// - `yearbook`: Generates an annual yearbook for reflection and sharing.
/// 
/// Conforms to:
/// - `RawRepresentable` (with `String` as the raw value; used for display names)
/// - `CaseIterable` (for iterating all features)
/// - `Identifiable` (using `self` as the unique identifier)
/// 
/// Also provides an `icon` property for each feature, returning the associated SF Symbol name.
enum PremiumFeature: String, CaseIterable, Identifiable {
    case unlimitedEntries = "Unlimited Daily Entries"
    case advancedInsights = "Mood & Keyword Trends"
    case yearlyStats = "Yearly Statistics"
    case aiSummaries = "Weekly AI Summaries"
    case yearbook = "Annual Yearbook Generator"
    
    var id: Self { self }
    
    var icon: String {
        switch self {
            case .unlimitedEntries: "infinity"
            case .advancedInsights: "chart.line.uptrend.xyaxis"
            case .yearlyStats: "chart.bar.fill"
            case .aiSummaries: "sparkles"
            case .yearbook: "book.closed"
        }
    }
}
