import Foundation
import SwiftUI

class WordService: ObservableObject {
    
    static func createFlockingBehavior() -> FlockingBehavior {
        return FlockingBehavior()
    }
}

class FlockingBehavior {
    private let separationRadius: CGFloat = 80
    private let alignmentRadius: CGFloat = 120
    private let cohesionRadius: CGFloat = 100
    
    func updatePosition(for word: Word, among words: [Word], in bounds: CGSize) -> CGPoint {
        let separation = separate(word, from: words)
        let alignment = align(word, with: words)
        let cohesion = cohere(word, to: words)
        let avoidBounds = avoidEdges(word, bounds: bounds)
        
        // Apply mood-based weighting
        let moodFactor = word.mood.animationSpeed
        
        var newVelocity = word.velocity
        newVelocity.dx += (separation.dx + alignment.dx + cohesion.dx + avoidBounds.dx) * moodFactor * 0.1
        newVelocity.dy += (separation.dy + alignment.dy + cohesion.dy + avoidBounds.dy) * moodFactor * 0.1
        
        // Limit velocity
        let maxSpeed: CGFloat = word.mood == .fearful ? 2.0 : 1.0
        let speed = sqrt(newVelocity.dx * newVelocity.dx + newVelocity.dy * newVelocity.dy)
        if speed > maxSpeed {
            newVelocity.dx = (newVelocity.dx / speed) * maxSpeed
            newVelocity.dy = (newVelocity.dy / speed) * maxSpeed
        }
        
        return CGPoint(
            x: word.position.x + newVelocity.dx,
            y: word.position.y + newVelocity.dy
        )
    }
    
    private func separate(_ word: Word, from words: [Word]) -> CGVector {
        var steer = CGVector.zero
        var count = 0
        
        for other in words {
            if other.id != word.id {
                let distance = distance(word.position, other.position)
                if distance < separationRadius && distance > 0 {
                    let diff = CGVector(
                        dx: word.position.x - other.position.x,
                        dy: word.position.y - other.position.y
                    )
                    let normalized = normalize(diff)
                    steer.dx += normalized.dx / distance
                    steer.dy += normalized.dy / distance
                    count += 1
                }
            }
        }
        
        if count > 0 {
            steer.dx /= CGFloat(count)
            steer.dy /= CGFloat(count)
        }
        
        return steer
    }
    
    private func align(_ word: Word, with words: [Word]) -> CGVector {
        var sum = CGVector.zero
        var count = 0
        
        for other in words {
            if other.id != word.id {
                let distance = distance(word.position, other.position)
                if distance < alignmentRadius {
                    sum.dx += other.velocity.dx
                    sum.dy += other.velocity.dy
                    count += 1
                }
            }
        }
        
        if count > 0 {
            sum.dx /= CGFloat(count)
            sum.dy /= CGFloat(count)
            return normalize(sum)
        }
        
        return CGVector.zero
    }
    
    private func cohere(_ word: Word, to words: [Word]) -> CGVector {
        var sum = CGPoint.zero
        var count = 0
        
        for other in words {
            if other.id != word.id {
                let distance = distance(word.position, other.position)
                if distance < cohesionRadius {
                    sum.x += other.position.x
                    sum.y += other.position.y
                    count += 1
                }
            }
        }
        
        if count > 0 {
            let target = CGPoint(x: sum.x / CGFloat(count), y: sum.y / CGFloat(count))
            return CGVector(
                dx: target.x - word.position.x,
                dy: target.y - word.position.y
            )
        }
        
        return CGVector.zero
    }
    
    private func avoidEdges(_ word: Word, bounds: CGSize) -> CGVector {
        let margin: CGFloat = 50
        var steer = CGVector.zero
        
        if word.position.x < margin {
            steer.dx = 1.0
        } else if word.position.x > bounds.width - margin {
            steer.dx = -1.0
        }
        
        if word.position.y < margin {
            steer.dy = 1.0
        } else if word.position.y > bounds.height - margin {
            steer.dy = -1.0
        }
        
        return steer
    }
    
    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return sqrt(dx * dx + dy * dy)
    }
    
    private func normalize(_ vector: CGVector) -> CGVector {
        let magnitude = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        if magnitude > 0 {
            return CGVector(dx: vector.dx / magnitude, dy: vector.dy / magnitude)
        }
        return CGVector.zero
    }
}