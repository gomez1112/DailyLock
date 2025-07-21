//
//  ModelContainerFactory.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import Foundation
import SwiftData

struct ModelContainerFactory {
    static let models: [any PersistentModel.Type] = [ MomentumEntry.self]
    static let schema = Schema(models)
    static func configuration(isStoredInMemoryOnly: Bool) -> ModelConfiguration {
        ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)
    }
   
    static let createSharedContainer: ModelContainer = {
        do {
            return try ModelContainer(for: schema, configurations: configuration(isStoredInMemoryOnly: false))
        } catch {
            fatalError("Could not create model container: \(error.localizedDescription)")
        }
    }()

    static func createPreviewContainer() throws -> ModelContainer {
        let container = try ModelContainer(for: schema, configurations: configuration(isStoredInMemoryOnly: true))
        let context = container.mainContext

        // Insert sample data for all models
        MomentumEntry.samples.forEach { context.insert($0) }
    
        return container
    }
}
