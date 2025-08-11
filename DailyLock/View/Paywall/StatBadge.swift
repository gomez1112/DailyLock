struct StatBadge: View {
    let number: String
    let label: String
    let icon: String
    let isAnimated: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.accent)
                .scaleEffect(isAnimated ? 1 : 0)
                .opacity(isAnimated ? 1 : 0)
            
            Text(number)
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 10)
            
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 10)
        }
        .animation(.spring(response: 0.5), value: isAnimated)
    }
}