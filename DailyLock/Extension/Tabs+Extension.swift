//
//  Tabs+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import Foundation
import SwiftUI

extension Tabs {
    @ViewBuilder
    var destination: some View {
        switch self {
            case .today: TodayViewContainer()
            case .timeline: TimelineHomeView()
            case .insights: InsightsView()
            case .settings: SettingsView()
            case .search: SearchView()
        }
    }
}
