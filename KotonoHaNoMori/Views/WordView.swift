import SwiftUI

struct WordView: View {
    let word: Word
    let onTap: (Word) -> Void
    let onTouch: (CGPoint) -> Void
    
    @State private var breathingScale: CGFloat = 1.0
    @State private var hoverScale: CGFloat = 1.0
    @State private var rotationOffset: Double = 0.0
    @State private var animationTimer: Timer?
    @StateObject private var audioService = AudioService()
    
    var body: some View {
        VStack(spacing: 2) {
            Text(word.text)
                .font(.system(size: word.fontSize, weight: fontWeight))
                .foregroundColor(word.color)
            
            Text(word.reading)
                .font(.system(size: word.fontSize * 0.6, weight: .light))
                .foregroundColor(readingColor)
        }
        .scaleEffect(word.scale * breathingScale * hoverScale)
        .rotationEffect(.degrees(word.rotation + rotationOffset))
        .position(word.position)
        .animation(.easeInOut(duration: 0.3), value: word.position)
        .animation(.easeInOut(duration: 0.2), value: word.rotation)
        .onTapGesture {
            audioService.playTapSound()
            audioService.speak(text: word.text)
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                hoverScale = 2.5
                rotationOffset += Double.random(in: -10...10)
            }
            
            onTouch(word.position)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTap(word)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.2)) {
                    hoverScale = 1.0
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    onTouch(value.location)
                    
                    withAnimation(.easeInOut(duration: 0.15)) {
                        hoverScale = 1.4
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        hoverScale = 1.0
                    }
                }
        )
        .onAppear {
            startBreathingAnimation()
        }
        .onDisappear {
            stopBreathingAnimation()
        }
    }
    
    private var fontWeight: Font.Weight {
        switch word.mood {
        case .sleepy: return .light
        case .calm: return .regular
        case .curious: return .medium
        case .playful: return .semibold
        case .fearful: return .bold
        }
    }
    
    private var readingColor: Color {
        switch word.type {
        case .english:
            return word.color.opacity(0.6)
        case .kanji:
            return word.color.opacity(0.7)
        case .hiragana:
            return Color(red: 0.9, green: 0.9, blue: 0.98).opacity(0.8)
        }
    }
    
    private func startBreathingAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Use the breathing phase from the word for consistent 2-second cycles
            let breathingCycle = sin(word.breathingPhase * 2.0 * .pi / 2.0) * word.mood.breathingAmplitude
            
            withAnimation(.linear(duration: 0.05)) {
                breathingScale = 1.0 + breathingCycle
            }
            
            // Add subtle rotation variation
            rotationOffset += Double.random(in: -0.1...0.1)
            rotationOffset = max(-5, min(5, rotationOffset))
        }
    }
    
    private func stopBreathingAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

#Preview {
    let sampleWord = Word(
        text: "静寂",
        reading: "せいじゃく",
        type: .kanji,
        position: CGPoint(x: 200, y: 300),
        mood: .calm
    )
    
    return WordView(
        word: sampleWord,
        onTap: { _ in },
        onTouch: { _ in }
    )
    .frame(width: 400, height: 600)
    .background(Color.white)
}