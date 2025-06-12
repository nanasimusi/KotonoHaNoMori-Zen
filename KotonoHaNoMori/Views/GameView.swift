import SwiftUI

struct GameView: View {
    @ObservedObject var gameState: GameState
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            // Background that captures touch events
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            viewModel.handleTouch(at: value.location)
                        }
                )
            
            ForEach(gameState.words) { word in
                WordView(
                    word: word,
                    onTap: { tappedWord in
                        withAnimation(.easeOut(duration: 0.5)) {
                            gameState.removeWord(tappedWord)
                        }
                    },
                    onTouch: { location in
                        viewModel.handleTouch(at: location)
                    }
                )
            }
        }
        .onAppear {
            viewModel.setGameState(gameState)
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