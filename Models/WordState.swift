import Foundation

enum WordState {
    case appearing
    case idle
    case breathing
    case moving
    case hovering
    case tapped
    case disappearing
}

struct WordAnimation {
    var state: WordState = .idle
    var progress: Double = 0.0
    var startTime: Date = Date()
    
    mutating func transition(to newState: WordState) {
        state = newState
        progress = 0.0
        startTime = Date()
    }
    
    var isAnimating: Bool {
        switch state {
        case .idle:
            return false
        default:
            return true
        }
    }
}