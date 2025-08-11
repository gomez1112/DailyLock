struct WelcomeView: View {
    @State private var appearAnimation = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated icon
            Image(systemName: "book.closed.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
                .symbolEffect(.bounce, value: appearAnimation)
                .scaleEffect(appearAnimation ? 1 : 0.5)
                .opacity(appearAnimation ? 1 : 0)
            
            VStack(spacing: 16) {
                Text("Welcome to DailyLock")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : 30)
                    .opacity(appearAnimation ? 1 : 0)
                
                Text("Capture life's moments,\none sentence at a time")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .offset(y: appearAnimation ? 0 : 30)
                    .opacity(appearAnimation ? 1 : 0)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appearAnimation = true
            }
        }
    }
}