//
//  ErrorRecoveryAction.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

enum ErrorRecoveryAction {
    case retry(action: () async -> Void)
    case settings
    case upgrade
    case contact
    case custom(label: String, action: () async -> Void)
    
    var label: String {
        switch self {
            case .retry: "Try Again"
            case .settings: "Open Settings"
            case .upgrade: "Upgrade"
            case .contact: "Contact Support"
            case .custom(let label, _): label
        }
    }
    
    var icon: String {
        switch self {
            case .retry: "arrow.clockwise"
            case .settings: "gear"
            case .upgrade: "crown"
            case .contact: "envelope"
            case .custom: "hand.tap"
        }
    }
}
