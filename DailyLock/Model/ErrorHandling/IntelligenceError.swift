//
//  IntelligenceError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

enum IntelligenceError: AppError {
    case appleIntelligenceNotEnabled
    case modelNotReady
    case generationFailed
    case insufficientData
    case quotaExceeded
    
    var title: String {
        switch self {
            case .appleIntelligenceNotEnabled: "Apple Intelligence Not Enabled"
            case .modelNotReady: "Model Not Ready"
            case .generationFailed: "Generation Failed"
            case .insufficientData: "More Entries Needed"
            case .quotaExceeded: "Limit Reached"
        }
    }
    
    var message: String {
        switch self {
            case .appleIntelligenceNotEnabled: "Apple Intelligence has not been turned on. Check Settings > Apple Intelligence."
            case .modelNotReady: "Waiting for more to download. Model is not ready yet."
            case .generationFailed: "Couldn't generate insights. Try again in a moment."
            case .insufficientData: "Write at least 5 entries to unlock AI insights."
            case .quotaExceeded: "You've reached today's insight limit. Try again tomorrow!"
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .appleIntelligenceNotEnabled: .settings
            case .modelNotReady: nil
            case .generationFailed: .retry(action: {})
            case .insufficientData: nil
            case .quotaExceeded: .upgrade
        }
    }
    
    var icon: String {
        switch self {
            case .insufficientData: "doc.text"
            case .quotaExceeded: "hourglass"
            default: "sparkles"
        }
    }
    
    var severity: ErrorSeverity {
        switch self {
            case .appleIntelligenceNotEnabled, .modelNotReady, .insufficientData, .quotaExceeded: .info
            case .generationFailed: .warning
        }
    }
}
