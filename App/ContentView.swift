import SwiftUI

struct ContentView: View {
    @StateObject private var gameState = GameState()
    @State private var showModeSelection = false
    
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
                } else if showModeSelection {
                    ModeSelectionView(gameState: gameState, showModeSelection: $showModeSelection)
                } else {
                    StartMenuView(gameState: gameState, showModeSelection: $showModeSelection)
                }
                
                VStack {
                    HStack {
                        if gameState.isPlaying || showModeSelection {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    gameState.stopGame()
                                    showModeSelection = false
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.black.opacity(0.6))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Text("言葉の森")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.black.opacity(0.7))
                        
                        Spacer()
                        
                        if gameState.isPlaying {
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Score: \(gameState.score)")
                                    .font(.headline)
                                    .foregroundColor(.black.opacity(0.8))
                                if let mode = gameState.selectedMode {
                                    Text(mode.displayName)
                                        .font(.caption)
                                        .foregroundColor(.black.opacity(0.5))
                                }
                            }
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
    @Binding var showModeSelection: Bool
    
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
                    showModeSelection = true
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

struct ModeSelectionView: View {
    @ObservedObject var gameState: GameState
    @Binding var showModeSelection: Bool
    
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                Text("Choose Your Journey")
                    .font(.title)
                    .fontWeight(.ultraLight)
                    .foregroundColor(.black.opacity(0.8))
                
                Text("学習モードを選択してください")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.black.opacity(0.6))
            }
            
            VStack(spacing: 30) {
                ModeButton(
                    title: "English Words",
                    subtitle: "英語学習",
                    description: "Learn basic English vocabulary",
                    mode: .english
                ) {
                    startGame(with: .english)
                }
                
                ModeButton(
                    title: "Kanji Characters",
                    subtitle: "漢字学習",
                    description: "Explore Japanese kanji and their meanings",
                    mode: .kanji
                ) {
                    startGame(with: .kanji)
                }
                
                ModeButton(
                    title: "Hiragana Words",
                    subtitle: "ひらがな学習",
                    description: "Practice Japanese hiragana reading",
                    mode: .hiragana
                ) {
                    startGame(with: .hiragana)
                }
                
                ModeButton(
                    title: "Mixed Challenge",
                    subtitle: "総合学習",
                    description: "All types of words combined",
                    mode: .mixed
                ) {
                    startGame(with: .mixed)
                }
            }
        }
        .padding(.horizontal, 40)
    }
    
    private func startGame(with mode: GameMode) {
        withAnimation(.easeInOut(duration: 0.5)) {
            gameState.setMode(mode)
            gameState.startGame()
            showModeSelection = false
        }
    }
}

struct ModeButton: View {
    let title: String
    let subtitle: String
    let description: String
    let mode: GameMode
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.black.opacity(0.8))
                        
                        Text(subtitle)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.black.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text(mode.emoji)
                        .font(.title2)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.5))
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}