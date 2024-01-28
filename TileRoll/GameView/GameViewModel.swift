import Foundation
import Combine

class GameViewModel : ObservableObject {
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
}
