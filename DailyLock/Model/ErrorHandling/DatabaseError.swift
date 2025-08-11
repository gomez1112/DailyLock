//
//  DabaseError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

enum DatabaseError: AppError {
    case saveFailed
    case loadFailed
    case deleteFailed
    case migrationFailed
    case entryNotFound
    case corruptedData
    
    var title: String {
        switch self {
            case .saveFailed: "Couldn't Save"
            case .loadFailed: "Loading Error"
            case .deleteFailed: "Deletion Failed"
            case .migrationFailed: "Update Error"
            case .entryNotFound: "Entry Not Found"
            case .corruptedData: "Data Issue"
        }
    }
    
    var message: String {
        switch self {
            case .saveFailed: "Your entry couldn't be saved. Don't worry, it's still in memory."
            case .loadFailed: "We're having trouble loading your entries. Try refreshing."
            case .deleteFailed: "The entry couldn't be deleted. Please try again."
            case .migrationFailed: "There was an issue updating your data format. Your entries are safe."
            case .entryNotFound: "We couldn't find that entry. It may have been deleted."
            case .corruptedData: "Some data appears corrupted. Contact support if this persists."
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .saveFailed, .loadFailed, .deleteFailed: .retry(action: {})
            case .migrationFailed, .corruptedData: .contact
            case .entryNotFound: nil
        }
    }
    
    var icon: String { severity.defaultIcon }
    
    var severity: ErrorSeverity {
        switch self {
            case .entryNotFound: .info
            case .saveFailed, .loadFailed, .deleteFailed: .warning
            case .migrationFailed: .error
            case .corruptedData: .critical
        }
    }
}
