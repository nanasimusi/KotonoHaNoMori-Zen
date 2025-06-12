import SwiftUI

extension Color {
    static let zenBackground = LinearGradient(
        colors: [Color.white, Color(red: 0.97, green: 0.97, blue: 0.97)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension CGPoint {
    static let zero = CGPoint(x: 0, y: 0)
    
    func distance(to point: CGPoint) -> CGFloat {
        let dx = x - point.x
        let dy = y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

extension CGVector {
    static let zero = CGVector(dx: 0, dy: 0)
    
    var magnitude: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    func normalized() -> CGVector {
        let mag = magnitude
        return mag > 0 ? CGVector(dx: dx / mag, dy: dy / mag) : .zero
    }
}

extension View {
    func zenStyle() -> some View {
        self
            .font(.system(.body, design: .rounded))
            .foregroundColor(.black.opacity(0.8))
    }
}