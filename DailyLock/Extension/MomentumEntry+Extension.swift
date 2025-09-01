//
//  MomentumEntry+Extension.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/1/25.
//

import Foundation

extension MomentumEntry {
    
    var entity: MomentumEntryEntity {
        .init(from: MomentumEntry(id: id, date: date, detail: detail, sentiment: sentiment, lockedAt: lockedAt))
    }
}

