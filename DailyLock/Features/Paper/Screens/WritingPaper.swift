//
//  WritingPaper.swift
//  DailyLock
//
//  Created by Gerard Gomez on 7/20/25.
//

import SwiftUI

struct WritingPaper: View {
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.isDark) var isDark

    private var hasUnlockedAnyTexture: Bool {
        // We ask the store directly if any of the texture IDs have been purchased.
        return ProductID.textures.contains { productID in
            dependencies.store.isPurchased(productID)
        }
    }
    private var textureImage: String {
        // Map texture IDs to image assets
        switch dependencies.syncedSetting.selectedTexture {
            case ProductID.brownTexture:
                return isDark ? "brownDarkTexture" : "brownLightTexture"
            case ProductID.vintageTexture:
                return isDark ? "vintageDarkTexture" : "vintageLightTexture"
            case ProductID.scientificTexture:
                return isDark ? "scientificDarkTexture" : "scientificLightTexture"
            case ProductID.waterColorStainedTexture:
                return isDark ? "watercolor-StainedDarkTexture" : "watercolor-StainedLightTexture"
            default:
                // Default paper texture
                return isDark ? "defaultDarkPaper" : "defaultLightPaper"
        }
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base paper with selected texture
                RoundedRectangle(cornerRadius: 20)
                    .fill((isDark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground))
                    .overlay(
                        // Apply selected texture as an overlay
                        Image(textureImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .allowsHitTesting(false)
                    )
                    .shadow(
                        color: (isDark ? DesignSystem.Shadow.darkShadowColor : DesignSystem.Shadow.lightShadowColor),
                        radius: DesignSystem.Shadow.shadowRegular,
                        y: 5
                    )
                    .accessibilityLabel("Writing paper with \(dependencies.syncedSetting.selectedTexture == "default" ? "default" : "custom") texture")
                    .accessibilityIdentifier("writingPaperBackground")
                
                // Red margin line (classic notebook style)
                HStack {
                    Rectangle()
                        .fill(Color.red.opacity(0.3))
                        .frame(width: 1)
                        .padding(.leading, 35)
                        .accessibilityLabel("Red margin line")
                        .accessibilityIdentifier("writingPaperMarginLine")
                    
                    Spacer()
                }
                
                // Subtle texture indicator (only if custom texture is selected)
                if dependencies.syncedSetting.selectedTexture != "default" && hasUnlockedAnyTexture {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                )
                                .padding(12)
                        }
                        Spacer()
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("writingPaperView")
        }
    }
}

#Preview(traits: .previewData) {
    WritingPaper()
}
