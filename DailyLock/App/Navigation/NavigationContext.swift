//
//  NavigationContext.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Observation
import SwiftUI

@Observable
final class NavigationContext {
    var selectedTab: Tabs = .today
    var path = NavigationPath()
    var presentedSheet: SheetDestination?
    
    func navigate(to tab: Tabs) {
        selectedTab = tab
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}

enum SheetDestination: Identifiable {
    case paywall
    case tips
    case entryDetail(entry: MomentumEntry)
    case textureStoreView
    
    var id: String {
        switch self {
            case .paywall: "paywall"
            case .tips: "tips"
            case .entryDetail(let entry): entry.id.uuidString
            case .textureStoreView: "textureStore"
        }
    }
}
