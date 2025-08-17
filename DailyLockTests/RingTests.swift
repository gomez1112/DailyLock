import Testing
@testable import DailyLock

@MainActor
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

    @Test("item(before:) returns nil for unknown elements")
    func itemBeforeReturnsNilForUnknownElement() {
        let ring = Ring([1, 2, 3])
        #expect(ring.item(before: 4) == nil)
    }

    @Test("item(after:) returns nil for unknown elements")
    func itemAfterReturnsNilForUnknownElement() {
        let ring = Ring([1, 2, 3])
        #expect(ring.item(after: 4) == nil)
    }

    @Test("single-element rings wrap to themselves")
    func singleElementRingWrapsToItself() {
        let ring = Ring([42])
        #expect(ring.item(before: 42) == 42)
        #expect(ring.item(after: 42) == 42)
    }

    @Test("subscript accesses and updates items")
    func subscriptAccessesAndUpdatesItems() {
        var ring = Ring([1, 2, 3])
        #expect(ring[1] == 2)
        ring[1] = 5
        #expect(ring[1] == 5)
        #expect(ring.count == 3)
        #expect(!ring.isEmpty)
    }
}
