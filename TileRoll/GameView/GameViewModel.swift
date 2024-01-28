import Foundation
import Combine

class GameViewModel : ObservableObject {
    // Dependencies
    private let gameManager : GameManager
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
}
