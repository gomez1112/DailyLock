//
//  Ring.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/17/25.
//


import Foundation

struct Ring<S: Equatable> {
    
    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    private var items: [S]

    init(_ items: [S]) {
        self.items = items
    }

    func item(before item: S) -> S? {
        guard !items.isEmpty, let i = items.firstIndex(of: item) else { return nil }
        return i > items.startIndex
            ? items[items.index(before: i)]
            : items[items.index(before: items.endIndex)] // wrap to last
    }

    func item(after item: S) -> S? {
        guard !items.isEmpty, let i = items.firstIndex(of: item) else { return nil }
        let last = items.index(before: items.endIndex)
        return i < last
            ? items[items.index(after: i)]
            : items[items.startIndex] // wrap to first
    }

    subscript(index: Int) -> S {
        get { items[index] }
        set { items[index] = newValue }
    }
}
