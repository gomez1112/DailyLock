import SwiftUI
import Testing
@testable import DailyLock

@MainActor
@Suite("Color Extension Tests")
struct ColorExtensionTests {
    
    @Test("Color(hex:) parses 6-digit hex correctly")
    func parsesSixDigitHex() {
        let color = Color(hex: "2c3e50")
        let expected = Color(.sRGB, red: 44/255, green: 62/255, blue: 80/255, opacity: 1.0)
        #expect(color?.isApproximatelyEqual(to: expected) ?? false)
    }

    @Test("Color(hex:) parses 3-digit hex correctly")
    func parsesThreeDigitHex() {
        let color = Color(hex: "abc")
        let expected = Color(.sRGB, red: 170/255, green: 187/255, blue: 204/255, opacity: 1.0)
        #expect(color?.isApproximatelyEqual(to: expected) ?? false)
    }

    @Test("Color(hex:) parses 8-digit hex (ARGB)")
    func parsesEightDigitHex() {
        let color = Color(hex: "802c3e50")
        let expected = Color(.sRGB, red: 44/255, green: 62/255, blue: 80/255, opacity: 128/255)
        #expect(color?.isApproximatelyEqual(to: expected) ?? false)
    }

    @Test("Semantic color properties produce expected values")
    func semanticColors() {
        #expect(ColorPalette.lightPaperBackground.isApproximatelyEqual(to: Color(hex: "FBF8F3") ?? .black))
        #expect(ColorPalette.darkPaperBackground.isApproximatelyEqual(to: Color(hex: "1C1C1E") ?? .black))
        #expect(ColorPalette.lightCardBackground.isApproximatelyEqual(to: Color(.white)))
        #expect(ColorPalette.darkCardBackground.isApproximatelyEqual(to: Color(hex: "2C2C2E") ?? .black))
        #expect(ColorPalette.lightLineColor.isApproximatelyEqual(to: Color(hex: "E8E8E8") ?? .black))
        #expect(ColorPalette.darkLineColor.isApproximatelyEqual(to: Color(hex: "3A3A3C") ?? .black))
        #expect(ColorPalette.lightInkColor.isApproximatelyEqual(to: Color(hex: "2c3e50") ?? .black))
        #expect(ColorPalette.darkInkColor.isApproximatelyEqual(to: Color(hex: "E5E5E7") ?? .black))
    }
}

// Helper function: Allow approximate equality match for Color.
extension Color {
    func isApproximatelyEqual(to other: Color, tolerance: Double = 0.01) -> Bool {
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        #if os(iOS) || os(tvOS) || os(watchOS)
        guard UIColor(self).getRed(&r1, green: &g1, blue: &b1, alpha: &a1),
              UIColor(other).getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return false }
        #elseif os(macOS)
        guard NSColor(self).usingColorSpace(.sRGB)?.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) == true,
              NSColor(other).usingColorSpace(.sRGB)?.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) == true else { return false }
        #endif
        return abs(Double(r1 - r2)) < tolerance && abs(Double(g1 - g2)) < tolerance && abs(Double(b1 - b2)) < tolerance && abs(Double(a1 - a2)) < tolerance
    }
}
