//
//  TaggingView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/9/25.
//

import FoundationModels
import os
import SwiftData
import SwiftUI
import Playgrounds

@Generable
struct TaggingResponse: Equatable {
    @Guide(.maximumCount(3))
    @Guide(description: "Tag the 3 most important actions and emotions in the given input text.")
    let tags: [Tag]
    
    @Generable
    struct Tag: Equatable {
        @Guide(description: "An important action and/or emotion in the given input text.")
        let text: String
    }
}

struct TaggingView: View {
    @Environment(AppDependencies.self) private var dependencies
    @Query private var entries: [MomentumEntry]
    @State private var generateTags: TaggingResponse.PartiallyGenerated?
    let contentTaggingModel = SystemLanguageModel(useCase: .contentTagging)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FlowLayout(alignment: .leading) {
                if let tags = generateTags?.tags {
                    ForEach(tags) { tag in
                        Text("#" + (tag.text ?? ""))
                            .tagStyle()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .animation(.default, value: generateTags)
        .transition(.opacity)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            print(entries.sorted { $0.date > $1.date }.prefix(7).map { $0.text }.joined(separator: "\n---\n"))
        }
        .task {
            if !contentTaggingModel.isAvailable {
                dependencies.errorState.showIntelligenceError(.appleIntelligenceNotEnabled)
            }
            do {
                let session = LanguageModelSession(model: contentTaggingModel, instructions: "Tag the 3 most important actions and emotions in the given input text. Be positive")
                let stream = session.streamResponse(to: entries.sorted { $0.date > $1.date }.prefix(7).map { $0.text }.joined(separator: "\n---\n"), generating: TaggingResponse.self ,options: GenerationOptions(sampling: .greedy))

                for try await newTags in stream {
                    generateTags = newTags.content
                }
                
            } catch {
                Log.intelligence.error("Generation failed: \(error.localizedDescription)")
                dependencies.errorState.showIntelligenceError(.generationFailed)
            }
        }
    }
}

#Preview(traits: .previewData) {
    TaggingView()
}
