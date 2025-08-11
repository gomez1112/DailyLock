//
//  NotificationError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

enum NotificationError: AppError {
    case permissionDenied
    case schedulingFailed
    case invalidTime
    
    var title: String {
        switch self {
            case .permissionDenied: "Notifications Disabled"
            case .schedulingFailed: "Scheduling Failed"
            case .invalidTime: "Invalid Time"
        }
    }
    
    var message: String {
        switch self {
            case .permissionDenied: "Enable notifications in Settings to receive daily reminders."
            case .schedulingFailed: "Couldn't schedule your reminder. Please try again."
            case .invalidTime: "Please select a valid time for your reminder."
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .permissionDenied: .settings
            case .schedulingFailed: .retry(action: {})
            case .invalidTime: nil
        }
    }
    
    var icon: String { "bell.slash" }
    var severity: ErrorSeverity { .warning }
}
