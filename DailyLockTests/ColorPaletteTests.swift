//
//  ColorPaletteTests.swift
//  DailyLockTests
//
//  Created by Gerard Gomez on 8/22/25.
//

import Testing
import SwiftUI
@testable import DailyLock

#if canImport(UIKit)
import UIKit
private typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
private typealias PlatformColor = NSColor
#endif

@MainActor
@Suite("ColorPalette")
struct ColorPaletteTests {
    
    // MARK: - Single color checks
    
    @Test("lightPaperBackground matches #FBF8F3")
    func lightPaperBackgroundHex() throws {
        try assert(ColorPalette.lightPaperBackground, equalsHex: "FBF8F3")
    }
    
    @Test("darkPaperBackground matches #1C1C1E")
    func darkPaperBackgroundHex() throws {
        try assert(ColorPalette.darkPaperBackground, equalsHex: "1C1C1E")
    }
    
    @Test("lightInkColor matches #2c3e50 (case-insensitive)")
    func lightInkHex() throws {
        try assert(ColorPalette.lightInkColor, equalsHex: "2c3e50")
    }
    
    @Test("darkInkColor matches #E5E5E7")
    func darkInkHex() throws {
        try assert(ColorPalette.darkInkColor, equalsHex: "E5E5E7")
    }
    
    @Test("lightCardBackground is pure white")
    func lightCardIsWhite() throws {
        try assert(ColorPalette.lightCardBackground, equalsHex: "FFFFFF")
    }
    
    // MARK: - Gradients & aliases
    
    @Test("Gradient sizes are correct and insightsCard == premium")
    func gradients() {
        #expect(ColorPalette.sentimentPositiveGradient.count == 3)
        #expect(ColorPalette.sentimentIndifferentGradient.count == 3)
        #expect(ColorPalette.sentimentNegativeGradient.count == 3)
        #expect(ColorPalette.premiumGradient.count == 2)
        #expect(ColorPalette.canLockLightGradient.count == 2)
        #expect(ColorPalette.canLockDarkGradient.count == 2)
        #expect(ColorPalette.insightsCardGradient == ColorPalette.premiumGradient)
    }
}

// MARK: - Helpers

extension ColorPaletteTests {
    /// Assert that a SwiftUI `Color` equals the given hex (RGB or RGBA), within a tiny tolerance.
    private func assert(_ color: Color, equalsHex hex: String, file: StaticString = #filePath, line: UInt = #line) throws {
        let expected = Self.rgba(fromHex: hex)
        let actual = try #require(Self.rgba(from: color), "Could not extract RGBA from Color")
        let tol: CGFloat = 1.0/255.0 + 0.0005
        
        #expect(abs(actual.r - expected.r) <= tol, "Red component mismatch")
        #expect(abs(actual.g - expected.g) <= tol, "Green component mismatch")
        #expect(abs(actual.b - expected.b) <= tol, "Blue component mismatch")
        #expect(abs(actual.a - expected.a) <= tol, "Alpha component mismatch")
    }
    
    /// Convert a 6- or 8-digit hex string (with or without leading #) to RGBA in 0...1
    private static func rgba(fromHex hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.removeFirst() }
        
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        
        let r, g, b, a: CGFloat
        switch s.count {
            case 6:
                r = CGFloat((v & 0xFF0000) >> 16) / 255
                g = CGFloat((v & 0x00FF00) >> 8) / 255
                b = CGFloat( v & 0x0000FF) / 255
                a = 1
            case 8:
                r = CGFloat((v & 0xFF000000) >> 24) / 255
                g = CGFloat((v & 0x00FF0000) >> 16) / 255
                b = CGFloat((v & 0x0000FF00) >> 8) / 255
                a = CGFloat( v & 0x000000FF) / 255
            default:
                // Fallback (won't be hit by your constants)
                r = 0; g = 0; b = 0; a = 1
        }
        return (r,g,b,a)
    }
    
    /// Extract RGBA components (0...1) from a SwiftUI `Color` via platform color bridging.
    private static func rgba(from color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
#if canImport(UIKit)
        let ui = PlatformColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard ui.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r,g,b,a)
#elseif canImport(AppKit)
        let ns = PlatformColor(color)
        guard let rgb = ns.usingColorSpace(.deviceRGB) else { return nil }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        rgb.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
#else
        return nil
#endif
    }
}

