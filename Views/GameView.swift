import SwiftUI

struct GameView: View {
    @ObservedObject var gameState: GameState
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            ForEach(gameState.words) { word in
                WordView(
                    word: word,
                    onTap: { tappedWord in
                        withAnimation(.easeOut(duration: 0.5)) {
                            gameState.removeWord(tappedWord)
                        }
                    }
                )
            }
        }
        .onAppear {
            viewModel.startAnimations()
        }
        .onDisappear {
            viewModel.stopAnimations()
        }
    }
}

#Preview {
    let gameState = GameState()
    gameState.startGame()
    return GameView(gameState: gameState)
}