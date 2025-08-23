//
//  IntentError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/22/25.
//

import Foundation

enum IntentError: AppError {
    case requiredSubscriptions
    case generationFailed
    case unavailableTips
    case noEntryFound
    
    var title: String {
        switch self {
            case .requiredSubscriptions: "Required Subscriptions"
            case .generationFailed: "Generation Failed"
            case .unavailableTips: "Unavailable Tips"
            case .noEntryFound: "No Entry Found"
        }
    }
    
    var message: String {
        switch self {
            case .requiredSubscriptions: "Please subscribe to DailyLock to access this feature."
            case .generationFailed: "Failed to generate a new Insight."
            case .unavailableTips: "No more tips available."
            case .noEntryFound: "No entry found. You need to start writing a new entry."
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .requiredSubscriptions, .generationFailed, .unavailableTips, .noEntryFound: .contact
        }
    }
    
    var icon: String {
        switch self {
            case .requiredSubscriptions: "lock"
            case .generationFailed: "xmark.circle"
            case .unavailableTips: "exclamationmark.circle"
            case .noEntryFound: "pencil"
        }
    }
    
    var severity: ErrorSeverity {
        switch self {
            case .requiredSubscriptions, .generationFailed: return .critical
            case .unavailableTips, .noEntryFound: return .warning
        }
    }
    
    
}
