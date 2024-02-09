import Foundation
import Combine
import SwiftUI

class MenuViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    @Published private(set) var highScore : Int = .zero
    @Published private(set) var isGameOver : Bool = false
    
    // Dependencies
    let gameManager : GameManager
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToScore()
        subscribeToGameState()
        subscribeToHighScore()
    }
}

// MARK: - Subscribers
private extension MenuViewModel {
    func subscribeToScore() {
        self.gameManager.$score
            .sink { [weak self] newScore in
                guard let self else { return }
                self.score = newScore
            }
            .store(in: &cancellables)
    }
    
    func subscribeToGameState() {
        self.gameManager.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                self.gameState = newGameState
                self.isGameOver = (newGameState == .over)
            }
            .store(in: &cancellables)
    }
    
    func subscribeToHighScore() {
        self.gameManager.$highScore
            .sink { [weak self] newHighScore in
                guard let self else { return }
                self.highScore = newHighScore
            }
            .store(in: &cancellables)
    }
}

// MARK: - Restart game
extension MenuViewModel {
    func startGame() {
        withAnimation {
            self.gameManager.startGame()
        }
    }
}

// MARK: - Return to menu
extension MenuViewModel {
    func returnToMenu() {
        withAnimation {
            self.gameManager.returnToMenu()
        }
    }
}
