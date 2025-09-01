//
//  Tabs.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftUI

/// A canonical list of top‑level destinations shown in the app’s tab interface.
///
/// Use `Tabs` to:
/// - Configure a `TabView` or `NavigationSplitView` with well‑known sections.
/// - Persist and restore the user’s selected tab (conforms to `Codable`, `Hashable`).
/// - Drive SwiftUI navigation (conforms to `Identifiable`, `CaseIterable`).
///
/// Each case provides:
/// - `title`: A human‑readable label appropriate for UI.
/// - `icon`: The SF Symbols name to display for the tab.
/// - `customizationID`: A stable identifier string suitable for analytics, deep‑links,
///   or Settings/Customization keys.
///
/// Example:
/// ```swift
/// TabView(selection: $selection) {
///     TodayView()
///         .tabItem { Label(Tabs.today.title, systemImage: Tabs.today.icon) }
///         .tag(Tabs.today)
///     // …
/// }
/// ```

/// The current day’s journaling or primary capture surface.
/// Designed to be the default landing experience.

/// A chronological view of entries or activities across dates.

/// Visual summaries and metrics derived from user data.

/// Global preferences and app configuration.

/// A dedicated search experience for finding content across the app.

/// The stable identity of a tab, equal to the case itself.
/// Useful for SwiftUI selection and diffable data sources.

/// A localized, user‑facing title for the tab.
/// Display this string in labels, navigation bars, or accessibility announcements.

/// The SF Symbols name associated with the tab.
/// Use with `Image(systemName:)` to render a platform‑native icon.

/// A stable, reverse‑DNS identifier for this tab, derived from its raw value.
/// Suitable for feature flags, analytics events, deep‑link routing, or
/// Settings/Customization storage (e.g., “com.transfinite.dailylock.today”).
enum Tabs: String, Identifiable, Hashable, CaseIterable, Codable {
    case today
    case timeline
    case insights
    case settings
    case search
    
    var id: Self { self }
    
    var title: String {
        switch self {
            case .today: "Today"
            case .timeline: "Timeline"
            case .insights: "Insights"
            case .settings: "Settings"
            case .search: "Search"
        }
    }
    
    var icon: String {
        switch self {
            case .today: "pencil.tip"
            case .timeline:"calendar"
            case .insights: "chart.line.uptrend.xyaxis"
            case .settings: "gear"
            case .search: "magnifyingglass"
        }
    }
    
    var customizationID: String {
        "com.transfinite.dailylock.\(rawValue)"
    }
}
