# Kotono-Ha no Mori (言葉の森)
*Words Forest - A Zen-themed Japanese Learning Game*

## Overview
Kotono-Ha no Mori is a beautifully minimal educational iOS app designed for children (ages 4-12) to learn Japanese language concepts through interactive gameplay. The app features floating Japanese words that respond organically to touch with zen-inspired animations.

## Features
- **Zen-inspired Design**: Clean, minimal interface with organic animations
- **Interactive Word Learning**: Tap words to hear pronunciation and see meanings
- **Breathing Animations**: Words gently "breathe" with mood-based behaviors
- **Japanese Text-to-Speech**: Native pronunciation of Japanese words
- **Ink Splash Effects**: Beautiful visual feedback on word interaction
- **Flocking Behavior**: Words move naturally using boid algorithms
- **Multiple Word Types**: English (with katakana), Kanji (with furigana), Hiragana (with romaji)

## Technical Stack
- **Language**: Swift
- **Framework**: SwiftUI + Combine
- **Architecture**: MVVM
- **Minimum Target**: iOS 15.0+
- **Bundle ID**: com.kotononahamori.app

## Project Structure
```
KotonoHaNoMori/
├── App/
│   ├── KotonoHaNoMoriApp.swift       # Main app entry point
│   └── ContentView.swift             # Root view with navigation
├── Models/
│   ├── Word.swift                    # Word data model
│   ├── WordState.swift               # Animation state management
│   └── GameState.swift               # Game logic and state
├── Views/
│   ├── GameView.swift                # Main game interface
│   ├── WordView.swift                # Individual word display
│   └── Components/
│       └── InkSplashView.swift       # Tap effect animation
├── ViewModels/
│   └── GameViewModel.swift           # MVVM business logic
├── Services/
│   ├── AudioService.swift            # Sound and TTS
│   └── WordService.swift             # Flocking algorithms
├── Utils/
│   └── Extensions.swift              # Swift extensions
└── Resources/
    ├── Assets.xcassets
    ├── Fonts/
    └── Sounds/
```

## How to Build and Run

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ target device or simulator
- macOS 12.0+ (for Xcode)

### Setup Instructions
1. **Create a new Xcode project**:
   ```bash
   # In Xcode, create a new iOS app project with:
   # - Product Name: KotonoHaNoMori
   # - Bundle Identifier: com.kotononahamori.app
   # - Language: Swift
   # - Interface: SwiftUI
   # - Minimum Deployment: iOS 15.0
   ```

2. **Copy the source files**:
   - Replace the default ContentView.swift with the provided version
   - Add all files from this repository to your Xcode project
   - Maintain the folder structure within Xcode groups

3. **Configure project settings**:
   - Set the Bundle Identifier to `com.kotononahamori.app`
   - Ensure iOS deployment target is set to 15.0 or later
   - Add required permissions in Info.plist if needed for audio

4. **Build and run**:
   - Select your target device or simulator
   - Press ⌘+R to build and run the project

### Key Features Implementation Status
- ✅ Core word display and positioning
- ✅ Tap-to-remove functionality with scoring
- ✅ Breathing animation system
- ✅ Japanese text-to-speech integration
- ✅ Zen-inspired visual design
- ✅ MVVM architecture implementation
- ✅ Basic ink splash effects
- ✅ Audio service with system sounds
- ⚠️ Flocking behavior (implemented but needs integration)
- ⚠️ Advanced particle effects (basic version included)

## Game Mechanics
1. **Start**: Tap "Begin" to start the game
2. **Interact**: Tap floating words to hear pronunciation and remove them
3. **Score**: Each word tapped increases your score
4. **Continuous Play**: New words appear to maintain game flow

## Design Philosophy
The app embodies **Ma (間)** - the Japanese concept of meaningful emptiness and negative space. Every animation is designed to feel organic and calming, avoiding jarring or aggressive feedback that might overwhelm young learners.

## Performance Targets
- **Frame Rate**: 60 FPS consistently
- **Memory Usage**: Under 50MB
- **Touch Response**: Sub-100ms feedback
- **Battery Optimization**: Minimal drain

## Customization
- **Word Database**: Modify `sampleWords` in `GameState.swift` to add new vocabulary
- **Animation Speed**: Adjust mood-based speeds in `WordMood` enum
- **Visual Styling**: Update colors and fonts in `Extensions.swift`
- **Audio**: Replace placeholder sounds in `AudioService.swift`

## Future Enhancements
- Dynamic word difficulty progression
- User progress tracking
- Custom word lists
- Multiplayer modes
- Additional language pairs
- Enhanced particle effects
- Background nature sounds

## Contributing
This project serves as a foundation for zen-inspired educational apps. Feel free to extend the vocabulary, improve animations, or add new interactive features while maintaining the minimalist aesthetic.

---
*Built with mindfulness for young learners discovering the beauty of Japanese language*