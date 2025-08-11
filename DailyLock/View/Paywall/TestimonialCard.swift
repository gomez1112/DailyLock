struct TestimonialCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let isAnimated: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "quote.opening")
                    .font(.title3)
                    .foregroundStyle(.accent.opacity(0.5))
                Spacer()
            }
            
            Text("DailyLock has transformed my journaling practice. The AI summaries help me see patterns I never noticed before.")
                .font(.body)
                .italic()
                .foregroundStyle(colorScheme == .dark ? AppColor.darkInkColor.opacity(0.9) : AppColor.lightInkColor.opacity(0.9))
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sarah M.")
                        .font(.subheadline.bold())
                    Text("365-day streak")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? AppColor.darkCardBackground : AppColor.lightCardBackground)
                .shadow(radius: 8)
        )
        .opacity(isAnimated ? 1 : 0)
        .scaleEffect(isAnimated ? 1 : 0.9)
    }
}