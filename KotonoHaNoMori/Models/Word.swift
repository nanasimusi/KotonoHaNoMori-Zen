import Foundation
import SwiftUI

struct Word: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let reading: String
    let type: WordType
    var position: CGPoint
    var mood: WordMood
    var scale: CGFloat = 1.0
    var rotation: Double = 0.0
    var velocity: CGVector = .zero
    var fontSize: CGFloat
    var breathingPhase: Double = 0.0
    var color: Color
    var direction: CGVector
    var baseSpeed: CGFloat
    var lastTouchTime: Date = Date.distantPast
    var isHovered: Bool = false
    
    init(text: String, reading: String, type: WordType, position: CGPoint = .zero, mood: WordMood = .calm) {
        self.text = text
        self.reading = reading
        self.type = type
        self.position = position
        self.mood = mood
        self.fontSize = CGFloat.random(in: 12...28)
        self.rotation = Double.random(in: -15...15)
        self.color = Self.randomColor()
        self.direction = CGVector(
            dx: Double.random(in: -1...1),
            dy: Double.random(in: -1...1)
        )
        self.baseSpeed = CGFloat.random(in: 0.3...1.2) * mood.animationSpeed
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
    
    static func randomColor() -> Color {
        let colors: [Color] = [
            .black.opacity(0.85),
            .blue.opacity(0.8),
            .purple.opacity(0.8),
            .green.opacity(0.8),
            .red.opacity(0.7),
            .orange.opacity(0.8),
            .brown.opacity(0.8),
            .gray.opacity(0.9)
        ]
        return colors.randomElement() ?? .black.opacity(0.85)
    }
    
    mutating func updateMovement(screenSize: CGSize, deltaTime: TimeInterval) {
        // Add slight random drift to direction
        let randomDrift = CGVector(
            dx: Double.random(in: -0.02...0.02),
            dy: Double.random(in: -0.02...0.02)
        )
        
        direction.dx += randomDrift.dx
        direction.dy += randomDrift.dy
        
        // Normalize direction to prevent speed buildup
        let magnitude = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        if magnitude > 0 {
            direction.dx /= magnitude
            direction.dy /= magnitude
        }
        
        // Apply movement based on mood and speed
        let speed = baseSpeed * CGFloat(deltaTime) * 20.0
        velocity.dx = direction.dx * speed
        velocity.dy = direction.dy * speed
        
        // Update position
        position.x += velocity.dx
        position.y += velocity.dy
        
        // Bounce off edges
        let padding: CGFloat = 50
        if position.x <= padding || position.x >= screenSize.width - padding {
            direction.dx *= -1
            position.x = max(padding, min(screenSize.width - padding, position.x))
        }
        
        if position.y <= padding || position.y >= screenSize.height - padding {
            direction.dy *= -1
            position.y = max(padding, min(screenSize.height - padding, position.y))
        }
        
        // Update breathing phase
        breathingPhase += deltaTime * mood.animationSpeed
        
        // Gradually reduce rotation for more natural movement
        rotation += Double.random(in: -0.5...0.5)
        rotation = max(-20, min(20, rotation))
    }
}

enum WordType: CaseIterable {
    case english
    case kanji
    case hiragana
    
    var readingColor: Color {
        switch self {
        case .english:
            return .black
        case .kanji:
            return .black
        case .hiragana:
            return Color(red: 0.9, green: 0.9, blue: 0.98)
        }
    }
}

enum WordMood: CaseIterable {
    case curious
    case calm
    case fearful
    case sleepy
    case playful
    
    var animationSpeed: Double {
        switch self {
        case .curious: return 1.2
        case .calm: return 0.8
        case .fearful: return 1.5
        case .sleepy: return 0.5
        case .playful: return 1.8
        }
    }
    
    var breathingAmplitude: CGFloat {
        switch self {
        case .curious: return 0.15
        case .calm: return 0.1
        case .fearful: return 0.2
        case .sleepy: return 0.25
        case .playful: return 0.18
        }
    }
    
    var flockRadius: CGFloat {
        switch self {
        case .curious: return 80
        case .calm: return 60
        case .fearful: return 100
        case .sleepy: return 40
        case .playful: return 120
        }
    }
    
    var separationRadius: CGFloat {
        switch self {
        case .curious: return 40
        case .calm: return 30
        case .fearful: return 60
        case .sleepy: return 20
        case .playful: return 50
        }
    }
    
    var touchResponseRadius: CGFloat {
        switch self {
        case .curious: return 80
        case .calm: return 60
        case .fearful: return 120
        case .sleepy: return 40
        case .playful: return 100
        }
    }
}