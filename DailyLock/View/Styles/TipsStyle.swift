struct TipsStyle: ProductViewStyle {
    @Environment(\.isDark) private var isDark
    func makeBody(configuration: Configuration) -> some View {
        switch configuration.state {
            case .loading: ProgressView()
            case .failure(let error): Text("Error: \(error.localizedDescription)")
            case .unavailable: Text("Unavailable")
            case .success(let product):
                HStack(spacing: 16) {
                    configuration.icon
                        .font(.title2)
                        .tint(.accentColor)
                        .frame(width: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.displayName)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(product.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(product.displayPrice)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                .padding()
                .cardBackground(cornerRadius: 16, shadowRadius: 4)
            
            @unknown default:
                fatalError()
        }
    }
}