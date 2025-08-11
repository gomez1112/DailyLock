struct GetStartedView: View {
    let onComplete: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated checkmarks
            VStack(spacing: 20) {
                ForEach(0..<3) { index in
                    HStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                            .scaleEffect(isAnimating ? 1 : 0)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(
                                .spring().delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                        
                        Text(checkmarkText(for: index))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(
                                .easeOut.delay(Double(index) * 0.2 + 0.1),
                                value: isAnimating
                            )
                    }
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                Text("You're All Set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Start capturing your first moment")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                onComplete()
            } label: {
                HStack {
                    Text("Begin Writing")
                    Image(systemName: "arrow.right")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .blue.opacity(0.3), radius: 10, y: 5)
            }
            .padding(.horizontal)
            .scaleEffect(isAnimating ? 1 : 0.9)
            .opacity(isAnimating ? 1 : 0)
            .animation(.spring().delay(0.8), value: isAnimating)
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .onAppear {
            isAnimating = true
        }
    }
    
    private func checkmarkText(for index: Int) -> String {
        switch index {
        case 0: return "Daily journaling made simple"
        case 1: return "Your thoughts are private & secure"
        case 2: return "Build a meaningful habit"
        default: return ""
        }
    }
}