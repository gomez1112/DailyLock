struct PremiumPreviewView: View {
    @State private var selectedFeature = 0
    
    let features = [
        ("Unlimited Entries", "infinity", "Capture every moment throughout your day"),
        ("AI Insights", "sparkles", "Discover patterns in your thoughts"),
        ("Mood Analytics", "chart.line.uptrend.xyaxis", "Track emotional journeys"),
        ("Annual Yearbook", "book.closed", "Beautiful year-end summaries")
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Crown animation
            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.pulse)
            
            Text("DailyLock+ Premium")
                .font(.title)
                .fontWeight(.bold)
            
            // Feature carousel
            TabView(selection: $selectedFeature) {
                ForEach(0..<features.count, id: \.self) { index in
                    FeatureCard(
                        icon: features[index].1,
                        title: features[index].0,
                        description: features[index].2
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 200)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button {
                    // Show paywall
                } label: {
                    Text("Start Free Trial")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Text("7 days free, then $4.99/month")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}