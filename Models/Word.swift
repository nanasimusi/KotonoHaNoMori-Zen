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
    
    init(text: String, reading: String, type: WordType, position: CGPoint = .zero, mood: WordMood = .calm) {
        self.text = text
        self.reading = reading
        self.type = type
        self.position = position
        self.mood = mood
        self.fontSize = CGFloat.random(in: 12...28)
        self.rotation = Double.random(in: -15...15)
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
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
}