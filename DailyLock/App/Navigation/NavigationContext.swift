/// The most recently pushed destination on the navigation stack, if any.
///
/// Use this to inspect what would be removed by a subsequent call to `pop()`
/// without actually mutating the navigation state.
///
/// Behavior:
/// - Returns `nil` when the navigation stack is empty.
/// - Does not modify the underlying `NavigationPath`.
///
/// Threading:
/// - Access from the main actor. `NavigationContext` is `@MainActor`.
///
/// Complexity:
/// - O(1)
///
/// Example:
/// ```swift
/// if let current = navigation.top {
///     // Decide whether to pop or present a different sheet based on `current`.
/// } else {
///     // Nothing on the stack
/// }
/// ```
//
//  NavigationContext.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Observation
import SwiftUI

@Observable
@MainActor
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
