import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var animationTimer: Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
    func startAnimations() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            self.updateAnimations()
        }
    }
    
    func stopAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateAnimations() {
        // This will be called 60 times per second to update word positions
        // and handle flocking behavior when implemented
    }
    
    deinit {
        stopAnimations()
        cancellables.removeAll()
    }
}