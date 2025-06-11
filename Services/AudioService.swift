import AVFoundation
import SwiftUI

class AudioService: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playTapSound() {
        // Placeholder for tap sound - in a real implementation,
        // you would load and play a sound file here
        AudioServicesPlaySystemSound(1104) // Use system water drop sound as placeholder
    }
    
    func speak(text: String, language: String = "ja-JP") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        utterance.volume = 0.7
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}