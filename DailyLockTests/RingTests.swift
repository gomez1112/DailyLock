import Testing
@testable import DailyLock

@Suite("Ring Tests")
struct RingTests {
    @Test("item(before:) wraps to last when called on first element")
    func itemBeforeWraps() {
        let ring = Ring([1, 2, 3])
        #expect(ring.item(before: 1) == 3)
        #expect(ring.item(before: 2) == 1)
    }

    @Test("item(after:) wraps to first when called on last element")
    func itemAfterWraps() {
        let ring = Ring([1, 2, 3])
        #expect(ring.item(after: 3) == 1)
        #expect(ring.item(after: 2) == 3)
    }
}
