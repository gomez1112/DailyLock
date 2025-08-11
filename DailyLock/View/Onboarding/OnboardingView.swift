struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(HapticEngine.self) private var haptics
    @AppStorage("hasCompletedOnboarding") private var hasCompleted = false
    
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    
    private let totalPages = 5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient that changes with pages
                AnimatedGradientBackground(currentPage: currentPage)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Skip button
                    HStack {
                        Spacer()
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .foregroundStyle(.secondary)
                        .padding()
                        .opacity(currentPage < totalPages - 1 ? 1 : 0)
                    }
                    
                    // Page content
                    TabView(selection: $currentPage) {
                        WelcomeView()
                            .tag(0)
                        
                        ConceptView()
                            .tag(1)
                        
                        NotificationPermissionView()
                            .tag(2)
                        
                        PremiumPreviewView()
                            .tag(3)
                        
                        GetStartedView(onComplete: completeOnboarding)
                            .tag(4)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)
                    
                    // Custom page indicator
                    CustomPageIndicator(
                        currentPage: currentPage,
                        totalPages: totalPages
                    )
                    .padding(.bottom, 50)
                }
            }
        }
        .statusBarHidden()
        .onChange(of: currentPage) { _, _ in
            haptics.select()
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.spring()) {
            hasCompleted = true
        }
        dismiss()
    }
}