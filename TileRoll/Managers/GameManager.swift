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

// MARK: - Start/End Game & Back to menu
extension GameManager {
    func startGame() {
        DispatchQueue.main.async {
            self.score = 0
            self.gameState = .playing
        }
    }
    
    func endGame() {
        DispatchQueue.main.async {
            self.gameState = .over
        }
    }
    
    func returnToMenu() {
        DispatchQueue.main.async {
            self.gameState = .menu
        }
    }
}
