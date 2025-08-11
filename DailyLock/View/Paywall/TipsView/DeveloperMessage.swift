private var developerMessage: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("A message from Gerard")
                        .font(.subheadline.bold())
                    Text("Solo developer")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        developerMessageExpanded.toggle()
                        haptics.tap()
                    }
                } label: {
                    Image(systemName: developerMessageExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            if developerMessageExpanded {
                Text("""
                Hey there! I'm Gerard, and I built DailyLock because I believe in the power of daily reflection. \
                As a solo developer, every tip helps me dedicate more time to making DailyLock better for you. \
                
                Your support means I can keep the app ad-free, add new features, and continue providing updates. \
                Thank you for being part of this journey! 🙏
                """)
                .font(.subheadline)
                .foregroundStyle(colorScheme == .dark ? ColorPalette.darkInkColor.opacity(0.9) : ColorPalette.lightInkColor.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? ColorPalette.darkCardBackground : ColorPalette.lightCardBackground)
                .shadow(radius: 8)
        )
        .accessibilityIdentifier("developerMessage")
    }