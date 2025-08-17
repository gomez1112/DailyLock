//
//  TextureStoreView.swift
//  DailyLock
//
//  Created by Gerard Gomez on 8/15/25.
//


import StoreKit
import SwiftUI

struct TextureStoreView: View {
    @Environment(\.isDark) private var isDark
    @Environment(AppDependencies.self) private var dependencies
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    // Use the refactored property from the Store
                    if dependencies.store.textureProducts.isEmpty {
                        ProgressView("Loading Textures...")
                            .padding(.top, 50)
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(dependencies.store.textureProducts) { product in
                                ProductView(id: product.id) {
                                    // This icon logic remains the same
                                    Image(ProductID.texturePreviews(isDark: isDark)[product.id] ?? "paperclip")
                                        .resizable()
                                }
                                .productViewStyle(.texture)
                            }
                        }
                    }
                    
                    restoreButton
                }
                .padding()
            }
            
#if os(iOS)
            .background(Color(uiColor: .systemGroupedBackground))
#else
            .background(Color(NSColor.windowBackgroundColor))
#endif
            .navigationTitle("Texture Store")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews (Unchanged)
    
    private var headerView: some View {
        VStack {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 40))
                .foregroundStyle(.accent.gradient)
                .symbolEffect(.bounce, value: dependencies.store.textureProducts.count)
            
            Text("Enhance Your Journal")
                .font(.largeTitle.bold())
                .fontDesign(.serif)
                .lineLimit(1)
                .minimumScaleFactor(0.93)
            
            Text("Upgrade your writing experience with these beautifully crafted paper textures.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var restoreButton: some View {
        Button {
            Task {
                try? await AppStore.sync()
            }
        } label: {
            Text("Restore Purchases")
                .font(.footnote.bold())
        }
        .padding()
        .tint(.secondary)
    }
}


// MARK: - Updated Product View Style

struct TextureProductStyle: ProductViewStyle {
    // Access the environment to get the store and the selected texture
    @Environment(AppDependencies.self) private var dependencies
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            configuration.icon
                .aspectRatio(1, contentMode: .fill)
                .frame(height: 120)
                .clipped()
                .overlay(alignment: .bottomTrailing) {
                    // Main logic is now in this helper view
                    if let product = configuration.product {
                        actionButton(for: product, with: configuration)
                            .padding(6)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(configuration.product?.displayName ?? "NA")
                    .font(.headline)
                    .minimumScaleFactor(0.8)
                Text(configuration.product?.description ?? "NA")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    /// This helper view builder decides which button to show based on purchase and selection state.
    @ViewBuilder
    private func actionButton(for product: Product, with configuration: Configuration) -> some View {
        let isPurchased = dependencies.store.isPurchased(product.id)
        let isSelected = (dependencies.syncedSetting.selectedTexture == product.id)
        
        if isPurchased {
            if isSelected {
                // State: Purchased and Applied
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Applied")
                }
                .font(.caption.bold())
                .foregroundStyle(.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.thinMaterial, in: Capsule())
                .accessibilityHint("This texture is currently applied.")
            } else {
                // State: Purchased, but not applied
                Button {
                    // Apply the texture by updating AppStorage
                    dependencies.syncedSetting.save(texture: product.id)
                    
                } label: {
                    Text("Apply")
                        .font(.caption.bold())
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accent.opacity(0.2))
                .accessibilityHint("Apply this purchased texture.")
            }
        } else {
            // State: Not purchased
            Button {
                configuration.purchase()
            } label: {
                Text(product.displayPrice)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
            }
            .buttonStyle(.bordered)
            .background(.thinMaterial, in: Capsule())
            .accessibilityHint("Purchase this texture for \(product.displayPrice).")
        }
    }
}

extension ProductViewStyle where Self == TextureProductStyle {
    static var texture: TextureProductStyle { .init() }
}

#Preview(traits: .previewData) {
    TextureStoreView()
}
