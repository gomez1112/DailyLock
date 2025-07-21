//
//  DataModel.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import Observation
import SwiftData

@Observable
final class DataModel {
    
    let store: Store
    let context: ModelContext
    
    init(container: ModelContainer) {
        self.store = Store()
        context = container.mainContext
    }
}
