import SwiftUI

enum GameMode: String, CaseIterable {
    case english = "English Words"
    case kanji = "Kanji Characters"
    case hiragana = "Hiragana Words"
    case mixed = "Mixed Challenge"
    
    var emoji: String {
        switch self {
        case .english: return "🌍"
        case .kanji: return "㊊"
        case .hiragana: return "あ"
        case .mixed: return "🌈"
        }
    }
}

struct ContentView: View {
    @State private var showModeSelection = false
    @State private var selectedMode: GameMode? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            Text("ことのはのもり")
                .font(.largeTitle)
                .fontWeight(.light)
            
            if let mode = selectedMode {
                // ゲーム画面
                VStack {
                    Text("\(mode.emoji) \(mode.rawValue)")
                        .font(.title)
                    
                    Text("選択されたモード")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Button("戻る") {
                        selectedMode = nil
                        showModeSelection = false
                    }
                }
            } else if showModeSelection {
                // モード選択画面
                VStack(spacing: 20) {
                    Text("モードを選択")
                        .font(.title2)
                    
                    ForEach(GameMode.allCases, id: \.self) { mode in
                        Button(action: {
                            selectedMode = mode
                        }) {
                            HStack {
                                Text(mode.emoji)
                                Text(mode.rawValue)
                                Spacer()
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                        .foregroundColor(.black)
                    }
                }
            } else {
                // スタート画面
                Button("Begin") {
                    showModeSelection = true
                }
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
