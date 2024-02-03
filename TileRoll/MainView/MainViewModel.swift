import Foundation
import Combine

class MainViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    
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
        subscribeToNewGameState()
    }
}

// MARK: - Subscribers
private extension MainViewModel {
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
    
    func subscribeToNewGameState() {
        self.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                if newGameState == .over {
                    
                }
            }
            .store(in: &cancellables)
    }
}
