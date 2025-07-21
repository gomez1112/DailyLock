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
    
    func navigate(to tab: Tabs) {
        selectedTab = tab
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
