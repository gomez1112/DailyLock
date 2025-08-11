struct TagStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .clipShape(Capsule())
            .background(colorScheme == .dark ? AnyShapeStyle(.thinMaterial) : AnyShapeStyle(.white.opacity(0.3)))
            .clipShape(Capsule())
    }
}