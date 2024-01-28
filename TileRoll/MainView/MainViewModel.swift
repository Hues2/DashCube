import Foundation
import Combine

class MainViewModel : ObservableObject {
    
    // Dependencies
    let gameManager : GameManager
    
    init(gameManager: GameManager) {
        self.gameManager = gameManager
    }
}
