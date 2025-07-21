//
//  Color+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftUI
#if os(macOS)
import AppKit
#endif

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
#if os(macOS)
        // On macOS, create NSColor first then convert to Color
        let nsColor = NSColor(
            calibratedRed: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            alpha: Double(a) / 255
        )
        self.init(nsColor)
#else
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
#endif
    }
    
    // MARK: - Semantic Colors for Dark Mode Support
    
    static var lightPaperBackground: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 251/255, green: 248/255, blue: 243/255, alpha: 1))
#else
        Color(hex: "FBF8F3")
#endif
    }
    static var darkPaperBackground: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 28/255, green: 28/255, blue: 30/255, alpha: 1))
#else
        Color(hex: "1C1C1E")
#endif
    }
    
    static var lightCardBackground: Color {
#if os(macOS)
        Color(NSColor.controlBackgroundColor)
#else
        Color(.white)
#endif
    }
    static var darkCardBackground: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 44/255, green: 44/255, blue: 46/255, alpha: 1))
#else
        Color(hex: "2C2C2E")
#endif
    }
    
    static var lightLineColor: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 232/255, green: 232/255, blue: 232/255, alpha: 1))
#else
        Color(hex: "E8E8E8")
#endif
    }
    static var darkLineColor: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 58/255, green: 58/255, blue: 60/255, alpha: 1))
#else
        Color(hex: "3A3A3C")
#endif
    }
    
    static var lightInkColor: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 44/255, green: 62/255, blue: 80/255, alpha: 1))
#else
        Color(hex: "2c3e50")
#endif
    }
    static var darkInkColor: Color {
#if os(macOS)
        Color(NSColor(calibratedRed: 229/255, green: 229/255, blue: 231/255, alpha: 1))
#else
        Color(hex: "E5E5E7")
#endif
    }
    static var lightShadowColor: Color {
#if os(macOS)
        Color(NSColor.black.withAlphaComponent(0.05))
#else
        Color(.black.opacity(0.05))
#endif
    }
    static var darkShadowColor: Color {
#if os(macOS)
        Color(NSColor.black.withAlphaComponent(0.3))
#else
            .black.opacity(0.3)
#endif
    }
}
