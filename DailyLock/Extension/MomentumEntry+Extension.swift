//
//  MomentumEntry+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/1/25.
//

import Foundation

extension MomentumEntry {
    static var samples: [MomentumEntry] {
        [
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 30*2), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 30*2)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 9), detail: "Started a new book and learned something insightful.", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 9)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 8), detail: "Work was challenging but I managed the stress.", sentiment: .indifferent,lockedAt: Date().addingTimeInterval(-86400 * 8)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 7), detail: "Felt under the weather today, stayed in mostly.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 7)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 6), detail: "Had an energizing workout in the morning!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 6)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 5), detail: "Productive day with a few interruptions.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 5)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 4), detail: "Argued with a friend, feeling regretful.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 4)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 3), detail: "Tried a new recipe, it was delicious!", sentiment: .positive, lockedAt: Date().addingTimeInterval(-86400 * 3)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 2), detail: "Average day, nothing much to note.", sentiment: .indifferent, lockedAt: Date().addingTimeInterval(-86400 * 2)),
            MomentumEntry(date: Date().addingTimeInterval(-86400 * 1), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date().addingTimeInterval(-86400 * 1)),
            MomentumEntry(date: Date(), title: "Saturday", detail: "Lost motivation and skipped tasks.", sentiment: .negative, lockedAt: Date.now)
        ]
    }
}

