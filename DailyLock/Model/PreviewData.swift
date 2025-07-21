//
//  PreviewData.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftData
import SwiftUI

struct PreviewData: PreviewModifier {
    static func makeSharedContext() async throws -> ModelContainer {
        try ModelContainerFactory.createPreviewContainer()
    }
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
            .environment(DataModel(container: context))
            .environment(NavigationContext())
            .environment(HapticEngine())
    }
}
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var previewData: Self = .modifier(PreviewData())
}
