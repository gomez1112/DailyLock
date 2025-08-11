//
//  ErrorSeverity.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/8/25.
//

import Foundation
import SwiftUI

enum ErrorSeverity {
    case info
    case warning
    case error
    case critical
    
    var color: Color {
        switch self {
            case .info: .blue
            case .warning: .orange
            case .error: .red
            case .critical: .purple
        }
    }
    
    var defaultIcon: String {
        switch self {
            case .info: "info.circle.fill"
            case .warning: "exclamationmark.triangle.fill"
            case .error: "xmark.circle.fill"
            case .critical: "exclamationmark.octagon.fill"
        }
    }
}
