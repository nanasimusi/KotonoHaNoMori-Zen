import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Color.white, Color(red: 0.97, green: 0.97, blue: 0.97)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if gameState.isPlaying {
                    GameView(gameState: gameState)
                } else {
                    StartMenuView(gameState: gameState)
                }
                
                VStack {
                    HStack {
                        Text("言葉の森")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.black.opacity(0.7))
                        
                        Spacer()
                        
                        if gameState.isPlaying {
                            Text("Score: \(gameState.score)")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .onAppear {
                gameState.updateScreenSize(geometry.size)
            }
            .onChange(of: geometry.size) { newSize in
                gameState.updateScreenSize(newSize)
            }
        }
    }
}

struct StartMenuView: View {
    @ObservedObject var gameState: GameState
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Kotono-Ha no Mori")
                .font(.largeTitle)
                .fontWeight(.ultraLight)
                .foregroundColor(.black.opacity(0.8))
            
            Text("言葉の森")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(.black.opacity(0.6))
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    gameState.startGame()
                }
            }) {
                Text("Begin")
                    .font(.title2)
                    .fontWeight(.light)
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    ContentView()
}