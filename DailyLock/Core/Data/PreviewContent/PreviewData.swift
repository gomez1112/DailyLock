//
//  PreviewData.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct PreviewData: PreviewModifier {
    private static let previewDependencies = AppDependencies(configuration: .preview)
    static func makeSharedContext() async throws -> ModelContainer {
        previewDependencies.dataService.context.container
    }
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(Self.previewDependencies.dataService.context.container)
            .environment(Self.previewDependencies)
    }
}
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var previewData: Self = .modifier(PreviewData())
}
