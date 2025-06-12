import AVFoundation
import Foundation

class OptimizedTTSManager: NSObject, ObservableObject {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var speechQueue: [AVSpeechUtterance] = []
    private var isProcessingQueue = false
    
    // Voice preferences
    private var preferredJapaneseVoice: AVSpeechSynthesisVoice?
    private var preferredEnglishVoice: AVSpeechSynthesisVoice?
    
    // Pronunciation dictionary
    private let japanesePronunciationDict: [String: String] = [
        "東京": "とうきょう",
        "大阪": "おおさか", 
        "京都": "きょうと",
        "横浜": "よこはま",
        "名古屋": "なごや",
        "神戸": "こうべ",
        "福岡": "ふくおか",
        "札幌": "さっぽろ",
        "仙台": "せんだい",
        "広島": "ひろしま",
        "学校": "がっこう",
        "先生": "せんせい",
        "学生": "がくせい",
        "友達": "ともだち",
        "家族": "かぞく",
        "今日": "きょう",
        "明日": "あした",
        "昨日": "きのう",
        "朝": "あさ",
        "昼": "ひる",
        "夜": "よる",
        "時間": "じかん",
        "分": "ふん",
        "秒": "びょう",
        "年": "ねん",
        "月": "つき",
        "日": "ひ",
        "曜日": "ようび",
        "月曜日": "げつようび",
        "火曜日": "かようび",
        "水曜日": "すいようび",
        "木曜日": "もくようび",
        "金曜日": "きんようび",
        "土曜日": "どようび",
        "日曜日": "にちようび"
    ]
    
    private let englishPronunciationDict: [String: String] = [
        "cat": "kæt",
        "dog": "dɔːɡ", 
        "bird": "bɜːrd",
        "fish": "fɪʃ",
        "tree": "triː",
        "flower": "ˈflaʊər",
        "water": "ˈwɔːtər",
        "fire": "ˈfaɪər",
        "earth": "ɜːrθ",
        "wind": "wɪnd",
        "sun": "sʌn",
        "moon": "muːn",
        "star": "stɑːr",
        "sky": "skaɪ",
        "cloud": "klaʊd",
        "rain": "reɪn",
        "snow": "snoʊ"
    ]
    
    override init() {
        super.init()
        setupAudioSession()
        selectOptimalVoices()
        speechSynthesizer.delegate = self
    }
    
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    private func selectOptimalVoices() {
        // Select best Japanese voice (prefer female, higher quality)
        let japaneseVoices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
            voice.language.hasPrefix("ja")
        }.sorted { voice1, voice2 in
            // Prefer enhanced quality voices
            if voice1.quality != voice2.quality {
                return voice1.quality.rawValue > voice2.quality.rawValue
            }
            // Prefer female voices for children
            return voice1.gender == .female && voice2.gender != .female
        }
        
        preferredJapaneseVoice = japaneseVoices.first ?? AVSpeechSynthesisVoice(language: "ja-JP")
        
        // Select best English voice (prefer child-friendly)
        let englishVoices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
            voice.language.hasPrefix("en")
        }.sorted { voice1, voice2 in
            // Prefer enhanced quality voices
            if voice1.quality != voice2.quality {
                return voice1.quality.rawValue > voice2.quality.rawValue
            }
            // Prefer female voices for children
            return voice1.gender == .female && voice2.gender != .female
        }
        
        preferredEnglishVoice = englishVoices.first ?? AVSpeechSynthesisVoice(language: "en-US")
        
        print("Selected Japanese voice: \(preferredJapaneseVoice?.name ?? "default")")
        print("Selected English voice: \(preferredEnglishVoice?.name ?? "default")")
    }
    
    func speak(text: String) {
        let language = detectLanguage(text: text)
        let optimizedText = applyPronunciationCorrections(text: text, language: language)
        
        let utterance = createOptimizedUtterance(text: optimizedText, language: language)
        
        // Add to queue with pre-utterance delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addToQueue(utterance: utterance)
        }
    }
    
    private func detectLanguage(text: String) -> String {
        // Simple language detection based on character sets
        let japaneseRange = text.rangeOfCharacter(from: CharacterSet(charactersIn: "\u{3040}-\u{309F}\u{30A0}-\u{30FF}\u{4E00}-\u{9FAF}"))
        
        if japaneseRange != nil {
            return "ja-JP"
        } else {
            return "en-US"
        }
    }
    
    private func applyPronunciationCorrections(text: String, language: String) -> String {
        var correctedText = text
        
        if language.hasPrefix("ja") {
            // Apply Japanese pronunciation corrections
            for (kanji, hiragana) in japanesePronunciationDict {
                correctedText = correctedText.replacingOccurrences(of: kanji, with: hiragana)
            }
        } else if language.hasPrefix("en") {
            // For English, we rely on the TTS engine's pronunciation
            // but could add phonetic spellings if needed
            correctedText = text.lowercased()
        }
        
        return correctedText
    }
    
    private func createOptimizedUtterance(text: String, language: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        
        if language.hasPrefix("ja") {
            // Japanese TTS Settings (optimized for children)
            utterance.voice = preferredJapaneseVoice
            utterance.rate = 0.45  // Slow and clear for children
            utterance.pitchMultiplier = 1.25  // Higher pitch, child-friendly
            utterance.volume = 0.8  // Comfortable volume
            utterance.preUtteranceDelay = 0.2
            utterance.postUtteranceDelay = 0.3  // Pause between words
        } else {
            // English TTS Settings (child-friendly)
            utterance.voice = preferredEnglishVoice
            utterance.rate = 0.45  // Clear pronunciation
            utterance.pitchMultiplier = 1.1  // Slightly higher pitch
            utterance.volume = 0.8
            utterance.preUtteranceDelay = 0.15
            utterance.postUtteranceDelay = 0.2
        }
        
        return utterance
    }
    
    private func addToQueue(utterance: AVSpeechUtterance) {
        speechQueue.append(utterance)
        processQueueIfNeeded()
    }
    
    private func processQueueIfNeeded() {
        guard !isProcessingQueue && !speechQueue.isEmpty else { return }
        
        isProcessingQueue = true
        let utterance = speechQueue.removeFirst()
        
        DispatchQueue.main.async {
            self.speechSynthesizer.speak(utterance)
        }
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        speechQueue.removeAll()
        isProcessingQueue = false
    }
    
    func pauseSpeaking() {
        speechSynthesizer.pauseSpeaking(at: .word)
    }
    
    func continueSpeaking() {
        speechSynthesizer.continueSpeaking()
    }
    
    // MARK: - Voice Information
    func getAvailableJapaneseVoices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("ja") }
    }
    
    func getAvailableEnglishVoices() -> [AVSpeechSynthesisVoice] {
        return AVSpeechSynthesisVoice.speechVoices().filter { $0.language.hasPrefix("en") }
    }
    
    func setCustomJapaneseVoice(_ voice: AVSpeechSynthesisVoice) {
        preferredJapaneseVoice = voice
    }
    
    func setCustomEnglishVoice(_ voice: AVSpeechSynthesisVoice) {
        preferredEnglishVoice = voice
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension OptimizedTTSManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isProcessingQueue = false
            self.processQueueIfNeeded()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isProcessingQueue = false
            self.speechQueue.removeAll()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        // Could be used for highlighting text as it's spoken
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Speech started - could trigger visual feedback
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        // Speech paused
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        // Speech continued
    }
}