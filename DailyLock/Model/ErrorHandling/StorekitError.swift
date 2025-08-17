//
//  StoreKitError.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation

enum StoreError: AppError {
    case purchaseFailed(String)
    case failedToLoadProducts
    case restorationFailed
    case productNotFound
    case paymentCancelled
    case networkError
    case verificationFailed
    
    var title: String {
        switch self {
            case .purchaseFailed: "Purchase Failed"
            case .failedToLoadProducts: "Failed to load products"
            case .restorationFailed: "Restoration Failed"
            case .productNotFound: "Product Unavailable"
            case .paymentCancelled: "Payment Cancelled"
            case .networkError: "Connection Issue"
            case .verificationFailed: "Verification Failed"
        }
    }
    
    var message: String {
        switch self {
            case .purchaseFailed(let details): "We couldn't complete your purchase. \(details)"
            case .failedToLoadProducts: "Failed to load products. Check your connection and try again."
            case .restorationFailed: "Unable to restore purchases. Check your connection and try again."
            case .productNotFound: "This product is temporarily unavailable. Please try later."
            case .paymentCancelled: "Your purchase was cancelled."
            case .networkError: "Check your internet connection and try again."
            case .verificationFailed: "We couldn't verify your purchase. Please contact support."
        }
    }
    
    var recoveryAction: ErrorRecoveryAction? {
        switch self {
            case .purchaseFailed, .failedToLoadProducts, .restorationFailed, .networkError: .retry(action: {})
            case .verificationFailed: .contact
            case .productNotFound, .paymentCancelled: nil
        }
    }
    
    var icon: String {
        switch self {
            case .paymentCancelled: "xmark.circle"
            case .networkError: "wifi.slash"
            default: severity.defaultIcon
        }
    }
    
    var severity: ErrorSeverity {
        switch self {
            case .paymentCancelled: .info
            case .purchaseFailed, .failedToLoadProducts, .productNotFound, .networkError: .warning
            case .restorationFailed, .verificationFailed: .error
        }
    }
}
