//
//  DailyEntry.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/23/25.
//

import Foundation
import WidgetKit

struct DailyEntry: TimelineEntry {
    let date: Date
    let hasEntry: Bool
    let entry: MomentumEntry?
}
