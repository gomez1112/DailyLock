struct ConceptView: View {
    @State private var typewriterText = ""
    @State private var showLock = false
    
    private let fullText = "Today was perfect. Coffee with mom, sunset walk, grateful."
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Visual demonstration
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.thinMaterial)
                    .frame(height: 200)
                
                VStack {
                    Text(typewriterText)
                        .font(.sentenceSerif)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if showLock {
                        Image(systemName: "lock.fill")
                            .font(.title)
                            .foregroundStyle(.blue)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .frame(maxWidth: 350)
            
            VStack(spacing: 16) {
                Text("One Sentence Daily")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Write what matters most today.\nLock it forever when ready.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            animateTypewriter()
        }
    }
    
    private func animateTypewriter() {
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                typewriterText.append(character)
                
                if index == fullText.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            showLock = true
                        }
                    }
                }
            }
        }
    }
}