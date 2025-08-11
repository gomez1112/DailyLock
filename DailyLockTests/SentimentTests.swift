import SwiftUI
import Testing
@testable import DailyLock

@Suite("Sentiment Enum Tests")
struct SentimentTests {
    @Test("Sentiment.allCases contains all cases")
    func testAllCases() {
        let cases = Sentiment.allCases
        #expect(cases.contains(.positive))
        #expect(cases.contains(.neutral))
        #expect(cases.contains(.negative))
        #expect(cases.count == 3)
    }

    @Test("Sentiment symbols are correct")
    func testSymbols() {
        #expect(Sentiment.positive.symbol == "sun.max.fill")
        #expect(Sentiment.neutral.symbol == "cloud.fill")
        #expect(Sentiment.negative.symbol == "cloud.rain.fill")
    }

    @Test("Sentiment gradients contain 3 colors each")
    func testGradients() {
        for sentiment in Sentiment.allCases {
            #expect(sentiment.gradient.count == 3)
        }
    }

    @Test("Sentiment inkIntensity values are correct")
    func testInkIntensity() {
        #expect(Sentiment.positive.inkIntensity == 0.9)
        #expect(Sentiment.neutral.inkIntensity == 0.7)
        #expect(Sentiment.negative.inkIntensity == 0.5)
    }

    @Test("Sentiment.id returns itself")
    func testId() {
        for sentiment in Sentiment.allCases {
            #expect(sentiment.id == sentiment)
        }
    }

    @Test("Sentiment.color is first gradient color")
    func testColor() {
        for sentiment in Sentiment.allCases {
            #expect(sentiment.color == sentiment.gradient.first)
        }
    }
}
