//
//  AppError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

protocol AppError: LocalizedError {
    
    var title: String { get }
    var message: String { get }
    var recoveryAction: ErrorRecoveryAction? { get }
    var icon: String { get }
    var severity: ErrorSeverity { get }
}
