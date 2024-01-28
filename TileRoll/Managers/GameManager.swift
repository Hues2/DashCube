import Foundation
import Combine

class GameManager {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = 0
}

// MARK: - Points
extension GameManager {
    func addPoint() {
        DispatchQueue.main.async {
            self.score += 1
        }
    }
}

// MARK: - Start/End Game
extension GameManager {
    func startGame() {
        self.score = 0
        self.gameState = .playing
    }
}
