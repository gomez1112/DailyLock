//
//  Tabs.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftUI

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
    
    @ViewBuilder
    var destination: some View {
        switch self {
            case .today: TodayView()
            case .timeline: Timeline()
            case .insights: InsightsView()
            case .settings: SettingsView()
            case .search: SearchView()
        }
    }
}
