import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var animationTimer: Timer?
    @Published var touchLocation: CGPoint?
    
    private var cancellables = Set<AnyCancellable>()
    private var lastUpdateTime: Date = Date()
    private var gameState: GameState?
    
    func setGameState(_ gameState: GameState) {
        self.gameState = gameState
    }
    
    func startAnimations() {
        lastUpdateTime = Date()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            self.updateAnimations()
        }
    }
    
    func stopAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    func handleTouch(at location: CGPoint) {
        touchLocation = location
        
        // Clear touch after a short time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.touchLocation == location {
                self.touchLocation = nil
            }
        }
    }
    
    private func updateAnimations() {
        guard let gameState = gameState else { return }
        
        let currentTime = Date()
        let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
        lastUpdateTime = currentTime
        
        // Update each word's position and apply flocking behavior
        var updatedWords = gameState.words
        
        for i in 0..<updatedWords.count {
            // Apply basic movement
            updatedWords[i].updateMovement(screenSize: gameState.screenSize, deltaTime: deltaTime)
            
            // Apply flocking behavior
            let flockingForce = calculateFlockingForce(for: updatedWords[i], in: updatedWords)
            updatedWords[i].direction.dx += flockingForce.dx * 0.1
            updatedWords[i].direction.dy += flockingForce.dy * 0.1
            
            // Apply touch response
            if let touchLocation = touchLocation {
                let touchForce = calculateTouchResponse(for: updatedWords[i], touchLocation: touchLocation)
                updatedWords[i].direction.dx += touchForce.dx * 0.3
                updatedWords[i].direction.dy += touchForce.dy * 0.3
            }
            
            // Normalize direction to prevent excessive speed
            let magnitude = sqrt(pow(updatedWords[i].direction.dx, 2) + pow(updatedWords[i].direction.dy, 2))
            if magnitude > 1.0 {
                updatedWords[i].direction.dx /= magnitude
                updatedWords[i].direction.dy /= magnitude
            }
        }
        
        // Update the game state
        DispatchQueue.main.async {
            gameState.words = updatedWords
        }
    }
    
    private func calculateFlockingForce(for word: Word, in words: [Word]) -> CGVector {
        var separation = CGVector.zero
        var alignment = CGVector.zero
        var cohesion = CGVector.zero
        
        var nearbyCount = 0
        
        for other in words {
            if other.id == word.id { continue }
            
            let distance = distanceBetween(word.position, other.position)
            
            // Separation: avoid crowding neighbors
            if distance < word.mood.separationRadius && distance > 0 {
                let diff = CGVector(
                    dx: word.position.x - other.position.x,
                    dy: word.position.y - other.position.y
                )
                let normalized = normalize(diff)
                separation.dx += normalized.dx / distance
                separation.dy += normalized.dy / distance
            }
            
            // Alignment and Cohesion: only with nearby words
            if distance < word.mood.flockRadius {
                alignment.dx += other.direction.dx
                alignment.dy += other.direction.dy
                
                cohesion.dx += other.position.x
                cohesion.dy += other.position.y
                
                nearbyCount += 1
            }
        }
        
        var totalForce = CGVector.zero
        
        // Apply separation (strongest force)
        if separation.dx != 0 || separation.dy != 0 {
            let normalizedSeparation = normalize(separation)
            totalForce.dx += normalizedSeparation.dx * 0.5
            totalForce.dy += normalizedSeparation.dy * 0.5
        }
        
        // Apply alignment and cohesion (weaker forces)
        if nearbyCount > 0 {
            // Alignment: move in the same direction as neighbors
            alignment.dx /= CGFloat(nearbyCount)
            alignment.dy /= CGFloat(nearbyCount)
            let normalizedAlignment = normalize(alignment)
            totalForce.dx += normalizedAlignment.dx * 0.1
            totalForce.dy += normalizedAlignment.dy * 0.1
            
            // Cohesion: move towards center of neighbors
            cohesion.dx = cohesion.dx / CGFloat(nearbyCount) - word.position.x
            cohesion.dy = cohesion.dy / CGFloat(nearbyCount) - word.position.y
            let normalizedCohesion = normalize(cohesion)
            totalForce.dx += normalizedCohesion.dx * 0.05
            totalForce.dy += normalizedCohesion.dy * 0.05
        }
        
        return totalForce
    }
    
    private func calculateTouchResponse(for word: Word, touchLocation: CGPoint) -> CGVector {
        let distance = distanceBetween(word.position, touchLocation)
        
        if distance < word.mood.touchResponseRadius {
            let force: CGFloat
            let direction: CGVector
            
            switch word.mood {
            case .curious:
                // Curious words are attracted to touch
                force = 0.3
                direction = CGVector(
                    dx: touchLocation.x - word.position.x,
                    dy: touchLocation.y - word.position.y
                )
            case .fearful:
                // Fearful words flee from touch
                force = 0.8
                direction = CGVector(
                    dx: word.position.x - touchLocation.x,
                    dy: word.position.y - touchLocation.y
                )
            case .playful:
                // Playful words circle around touch
                force = 0.4
                let angle = atan2(touchLocation.y - word.position.y, touchLocation.x - word.position.x) + .pi/2
                direction = CGVector(dx: cos(angle), dy: sin(angle))
            default:
                // Calm and sleepy words have mild repulsion
                force = 0.2
                direction = CGVector(
                    dx: word.position.x - touchLocation.x,
                    dy: word.position.y - touchLocation.y
                )
            }
            
            let normalizedDirection = normalize(direction)
            let distanceFactor = 1.0 - (distance / word.mood.touchResponseRadius)
            
            return CGVector(
                dx: normalizedDirection.dx * force * distanceFactor,
                dy: normalizedDirection.dy * force * distanceFactor
            )
        }
        
        return CGVector.zero
    }
    
    private func distanceBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
    private func normalize(_ vector: CGVector) -> CGVector {
        let magnitude = sqrt(pow(vector.dx, 2) + pow(vector.dy, 2))
        if magnitude > 0 {
            return CGVector(dx: vector.dx / magnitude, dy: vector.dy / magnitude)
        }
        return CGVector.zero
    }
    
    deinit {
        stopAnimations()
        cancellables.removeAll()
    }
}