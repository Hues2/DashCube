import Foundation
import Combine

class GameViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    
    // Timer
    @Published private(set) var seconds : Int = 0
    @Published private(set) var milliseconds: Int = 0
    
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
        subscribeToSeconds()
        subscribeToMilliseconds()
    }
}

// MARK: - Subscribers
private extension GameViewModel {
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
            }
            .store(in: &cancellables)
    }
    
    func subscribeToSeconds() {
        self.gameManager.$seconds
            .sink { [weak self] newSeconds in
                guard let self else { return }
                self.seconds = newSeconds
            }
            .store(in: &cancellables)
    }
    
    func subscribeToMilliseconds() {
        self.gameManager.$milliseconds
            .sink { [weak self] newMilliSeconds in
                guard let self else { return }
                self.milliseconds = newMilliSeconds
            }
            .store(in: &cancellables)
    }
}

// MARK: - Restart game
extension GameViewModel {
    func restartGame() {
        self.gameManager.startGame()
    }
}

// MARK: - Return to menu
extension GameViewModel {
    func returnToMenu() {
        self.gameManager.returnToMenu()
    }
}
