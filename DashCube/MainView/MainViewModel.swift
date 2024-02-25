import Foundation
import Combine
import SwiftUI

class MainViewModel : ObservableObject {
    @Published var gameState : GameState = .menu
    
    // Dependencies
    let gameManager : GameManager
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToGameState()
    }
}

// MARK: - Subscribers
private extension MainViewModel {
    func subscribeToGameState() {
        self.gameManager.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                withAnimation(.spring) {
                    self.gameState = newGameState
                }
            }
            .store(in: &cancellables)
    }
}
