import SwiftUI

struct InkSplashView: View {
    let position: CGPoint
    @State private var splashProgress: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Main splash circle
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80 * splashProgress, height: 80 * splashProgress)
                .opacity(opacity)
            
            // Smaller splash droplets
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: 8, height: 8)
                    .offset(
                        x: cos(Double(index) * .pi / 4) * 60 * splashProgress,
                        y: sin(Double(index) * .pi / 4) * 60 * splashProgress
                    )
                    .opacity(opacity)
                    .scaleEffect(splashProgress)
            }
        }
        .position(position)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                splashProgress = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.3).delay(0.2)) {
                opacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onComplete()
            }
        }
    }
}

struct InkSplashModifier: ViewModifier {
    @State private var splashes: [InkSplash] = []
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            ForEach(splashes, id: \.id) { splash in
                InkSplashView(position: splash.position) {
                    removeSplash(splash)
                }
            }
        }
    }
    
    func addSplash(at position: CGPoint) {
        let splash = InkSplash(position: position)
        splashes.append(splash)
    }
    
    private func removeSplash(_ splash: InkSplash) {
        splashes.removeAll { $0.id == splash.id }
    }
}

struct InkSplash: Identifiable {
    let id = UUID()
    let position: CGPoint
}

extension View {
    func inkSplashEffect() -> some View {
        self.modifier(InkSplashModifier())
    }
}