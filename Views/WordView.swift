import SwiftUI

struct WordView: View {
    let word: Word
    let onTap: (Word) -> Void
    
    @State private var breathingScale: CGFloat = 1.0
    @State private var hoverScale: CGFloat = 1.0
    @State private var animationTimer: Timer?
    @StateObject private var audioService = AudioService()
    
    var body: some View {
        VStack(spacing: 2) {
            Text(word.text)
                .font(.system(size: word.fontSize, weight: .regular))
                .foregroundColor(.black.opacity(0.85))
            
            Text(word.reading)
                .font(.system(size: word.fontSize * 0.6, weight: .light))
                .foregroundColor(word.type.readingColor.opacity(0.7))
        }
        .scaleEffect(word.scale * breathingScale * hoverScale)
        .rotationEffect(.degrees(word.rotation))
        .position(word.position)
        .onTapGesture {
            audioService.playTapSound()
            audioService.speak(text: word.text)
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                hoverScale = 2.5
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTap(word)
            }
        }
        .onHover { isHovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                hoverScale = isHovering ? 1.3 : 1.0
            }
        }
        .onAppear {
            startBreathingAnimation()
        }
        .onDisappear {
            stopBreathingAnimation()
        }
    }
    
    private func startBreathingAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            let time = Date().timeIntervalSince1970
            let breathingCycle = sin(time * word.mood.animationSpeed) * word.mood.breathingAmplitude
            
            withAnimation(.linear(duration: 0.05)) {
                breathingScale = 1.0 + breathingCycle
            }
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
    
    return WordView(word: sampleWord) { _ in }
        .frame(width: 400, height: 600)
        .background(Color.white)
}