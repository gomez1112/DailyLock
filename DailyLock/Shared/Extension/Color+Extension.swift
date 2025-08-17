//
//  Color+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

/// An extension to create a Color from a hexadecimal string.
extension Color {
    /// Creates a color from a hex string (e.g., "#FF5733" or "FF5733").
    ///
    /// Supports 3-digit (RGB), 6-digit (RGB), and 8-digit (ARGB) formats.
    /// Returns `nil` if the hex string is invalid.
    ///
    /// - Parameter hex: The hexadecimal color string.
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        // Return nil for invalid lengths
        if ![3, 6, 8].contains(hex.count) {
            return nil
        }
        
        var int: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&int) else {
            return nil // Return nil if scanning fails
        }
        
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                // This case is now unreachable because of the count check above,
                // but is required by the compiler.
                (a, r, g, b) = (0, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
