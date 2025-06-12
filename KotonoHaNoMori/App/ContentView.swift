import SwiftUI

struct ContentView: View {
    @State private var showGame = false
    
    var body: some View {
        VStack(spacing: 40) {
            Text("ことのはのもり")
                .font(.largeTitle)
                .fontWeight(.light)
            
            if showGame {
                Text("ゲーム画面")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Button("戻る") {
                    showGame = false
                }
            } else {
                Button("Begin") {
                    showGame = true
                }
                .font(.title2)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
