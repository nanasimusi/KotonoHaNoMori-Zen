import AVFoundation
import SwiftUI

class AudioService: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    private let ttsManager = OptimizedTTSManager()
    
    // Sound effect configurations
    private let tapSoundEffects: [SystemSoundID] = [
        1104, // Water drop
        1105, // Pop
        1106, // Peek
        1107, // Tick
        1108  // Tock
    ]
    
    init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // Use .playback category for better TTS quality
            try audioSession.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .allowBluetooth])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playTapSound() {
        // Play a random gentle tap sound for variety
        let randomSound = tapSoundEffects.randomElement() ?? 1104
        AudioServicesPlaySystemSound(randomSound)
        
        // Add subtle haptic feedback for supported devices
        let impactGenerator = UIImpactFeedbackGenerator(style: .light)
        impactGenerator.impactOccurred()
    }
    
    func speak(text: String) {
        // Use the optimized TTS manager with automatic language detection
        ttsManager.speak(text: text)
    }
    
    func stopSpeaking() {
        ttsManager.stopSpeaking()
    }
    
    func pauseSpeaking() {
        ttsManager.pauseSpeaking()
    }
    
    func continueSpeaking() {
        ttsManager.continueSpeaking()
    }
    
    // MARK: - Advanced TTS Controls
    
    func getAvailableJapaneseVoices() -> [AVSpeechSynthesisVoice] {
        return ttsManager.getAvailableJapaneseVoices()
    }
    
    func getAvailableEnglishVoices() -> [AVSpeechSynthesisVoice] {
        return ttsManager.getAvailableEnglishVoices()
    }
    
    func setCustomJapaneseVoice(_ voice: AVSpeechSynthesisVoice) {
        ttsManager.setCustomJapaneseVoice(voice)
    }
    
    func setCustomEnglishVoice(_ voice: AVSpeechSynthesisVoice) {
        ttsManager.setCustomEnglishVoice(voice)
    }
    
    // MARK: - Audio Session Management
    
    func handleAppBackgrounding() {
        do {
            // Allow audio to continue in background
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
        } catch {
            print("Failed to configure background audio: \(error)")
        }
    }
    
    func handleAppForegrounding() {
        do {
            // Restore optimal TTS settings
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to restore foreground audio: \(error)")
        }
    }
    
    // MARK: - Zen Audio Effects
    
    func playZenTransitionSound() {
        // Play a subtle bell sound for zen-like transitions
        AudioServicesPlaySystemSound(1013) // Glass ping sound
    }
    
    func playWordAppearSound() {
        // Gentle sound when words appear
        AudioServicesPlaySystemSound(1000) // Soft notification
    }
    
    func playWordDisappearSound() {
        // Subtle sound when words disappear
        AudioServicesPlaySystemSound(1001) // Quiet pop
    }
}