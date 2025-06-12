import Foundation
import SwiftUI

enum GameMode: CaseIterable {
    case english
    case kanji
    case hiragana
    case mixed
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .kanji: return "漢字"
        case .hiragana: return "ひらがな"
        case .mixed: return "Mixed"
        }
    }
    
    var emoji: String {
        switch self {
        case .english: return "🌍"
        case .kanji: return "㊊"
        case .hiragana: return "あ"
        case .mixed: return "🌈"
        }
    }
}

class GameState: ObservableObject {
    @Published var words: [Word] = []
    @Published var score: Int = 0
    @Published var isPlaying: Bool = false
    @Published var screenSize: CGSize = .zero
    @Published var selectedMode: GameMode?
    
    private let maxWords: Int = 15
    private let minWords: Int = 8
    
    let sampleWords: [Word] = [
        Word(text: "cat", reading: "キャット", type: .english, mood: .curious),
        Word(text: "dog", reading: "ドッグ", type: .english, mood: .playful),
        Word(text: "bird", reading: "バード", type: .english, mood: .calm),
        Word(text: "fish", reading: "フィッシュ", type: .english, mood: .sleepy),
        Word(text: "tree", reading: "ツリー", type: .english, mood: .calm),
        Word(text: "flower", reading: "フラワー", type: .english, mood: .curious),
        Word(text: "伝心", reading: "でんしん", type: .kanji, mood: .calm),
        Word(text: "静寂", reading: "せいじゃく", type: .kanji, mood: .sleepy),
        Word(text: "自然", reading: "しぜん", type: .kanji, mood: .calm),
        Word(text: "平和", reading: "へいわ", type: .kanji, mood: .calm),
        Word(text: "美しい", reading: "うつくしい", type: .kanji, mood: .curious),
        Word(text: "優しい", reading: "やさしい", type: .kanji, mood: .calm),
        Word(text: "ひかり", reading: "hikari", type: .hiragana, mood: .curious),
        Word(text: "みずうみ", reading: "mizuumi", type: .hiragana, mood: .calm),
        Word(text: "そよかぜ", reading: "soyokaze", type: .hiragana, mood: .playful),
        Word(text: "つきよ", reading: "tsukiyo", type: .hiragana, mood: .sleepy),
        Word(text: "さくら", reading: "sakura", type: .hiragana, mood: .curious),
        Word(text: "みどり", reading: "midori", type: .hiragana, mood: .calm)
    ]
    
    func setMode(_ mode: GameMode) {
        selectedMode = mode
    }
    
    func startGame() {
        isPlaying = true
        score = 0
        populateWords()
    }
    
    func stopGame() {
        isPlaying = false
        words.removeAll()
        selectedMode = nil
    }
    
    func removeWord(_ word: Word) {
        guard let index = words.firstIndex(of: word) else { return }
        words.remove(at: index)
        score += 1
        
        if words.count < minWords {
            addRandomWord()
        }
    }
    
    private func populateWords() {
        words.removeAll()
        let initialCount = Int.random(in: minWords...maxWords)
        
        for _ in 0..<initialCount {
            addRandomWord()
        }
    }
    
    private func addRandomWord() {
        let availableWords = getWordsForCurrentMode()
        guard !availableWords.isEmpty else { return }
        
        var newWord = availableWords.randomElement()!
        newWord.position = randomPosition()
        newWord.mood = WordMood.allCases.randomElement()!
        
        words.append(newWord)
    }
    
    private func getWordsForCurrentMode() -> [Word] {
        guard let mode = selectedMode else { return sampleWords }
        
        switch mode {
        case .english:
            return sampleWords.filter { $0.type == .english }
        case .kanji:
            return sampleWords.filter { $0.type == .kanji }
        case .hiragana:
            return sampleWords.filter { $0.type == .hiragana }
        case .mixed:
            return sampleWords
        }
    }
    
    private func randomPosition() -> CGPoint {
        let padding: CGFloat = 60
        let x = CGFloat.random(in: padding...(screenSize.width - padding))
        let y = CGFloat.random(in: padding...(screenSize.height - padding))
        return CGPoint(x: x, y: y)
    }
    
    func updateScreenSize(_ size: CGSize) {
        screenSize = size
    }
}