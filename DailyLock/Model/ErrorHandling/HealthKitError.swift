//
//  HealthKitError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/16/25.
//

import Foundation

enum HealthKitError: AppError {
    case notAvailable
    case authorizationDenied
    case authorizationNotDetermined
    case saveFailed(String)
    case queryFailed(String)
    case syncFailed(String)
    case invalidData
    
    var title: String {
        switch self {
            case .notAvailable: "Health Not Available"
            case .authorizationDenied: "Permission Denied"
            case .authorizationNotDetermined: "Permission Required"
            case .saveFailed: "Save Failed"
            case .queryFailed: "Query Failed"
            case .syncFailed: "Sync Failed"
            case .invalidData: "Invalid Data"
        }
    }
    
    var message: String {
        switch self {
            case .notAvailable:
                "Health app is not available on this device."
            case .authorizationDenied:
                "You've denied access to Health. Enable it in Settings to sync your mood data."
            case .authorizationNotDetermined:
                "Grant permission to sync your mood data with Apple Health."
            case .saveFailed(let detail):
                "Couldn't save to Health: \(detail)"
            case .queryFailed(let detail):
                "Couldn't read from Health: \(detail)"
            case .syncFailed(let detail): "Failed to sync: \(detail)"
            case .invalidData:
                "The health data appears to be invalid."
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .authorizationDenied, .authorizationNotDetermined: .settings
            case .saveFailed, .queryFailed: .retry(action: {})
            default: nil
        }
    }
    
    var icon: String { "heart.text.square" }
    var severity: ErrorSeverity {
        switch self {
            case .notAvailable, .authorizationNotDetermined: .info
            case .authorizationDenied, .invalidData: .warning
            case .saveFailed, .syncFailed, .queryFailed: .error
        }
    }
}
