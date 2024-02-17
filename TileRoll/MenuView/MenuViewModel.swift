import Foundation
import Combine
import SwiftUI

class MenuViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    @Published private(set) var highScore : Int = .zero
    @Published private(set) var isGameOver : Bool = false
    
    // Player Cube
    @Published var selectedPlayerCube : PlayerCube
    // Cubes
    @Published private(set) var cubes : [PlayerCube] = []
    
    // Dependencies
    let gameManager : GameManager
    let cubesManager: CubesManager
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager, cubesManager: CubesManager) {
        self.gameManager = gameManager
        self.cubesManager = cubesManager
        self.selectedPlayerCube = cubesManager.selectedCube
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToScore()
        subscribeToGameState()
        subscribeToHighScore()
        subscribeToCubes()
        subscribeToSelectedPlayerCube()
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
                self.isGameOver = ((newGameState == .over(timerEnded: true)) || (newGameState == .over(timerEnded: false)))
            }
            .store(in: &cancellables)
    }
    
    func subscribeToHighScore() {
        self.gameManager.$highScore
            .sink { [weak self] newHighScore in
                guard let self else { return }
                self.highScore = newHighScore
                // Highscore has changed, so try to unlock cubes
                self.unlockCubes(newHighScore)
            }
            .store(in: &cancellables)
    }
    
    func subscribeToSelectedPlayerCube() {
        self.$selectedPlayerCube
            .dropFirst()
            .sink { [weak self] newSelectedPlayerCube in
                guard let self else { return }
                self.cubesManager.saveSelectedCubeId(newSelectedPlayerCube.id)
            }
            .store(in: &cancellables)
    }
    
    func subscribeToCubes() {
        self.cubesManager.$cubes            
            .sink { [weak self] newCubes in
                guard let self else { return }
                print("MENU VM cubes \n \(newCubes)")
                self.cubes = newCubes
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

private extension MenuViewModel {
    func unlockCubes(_ highScore : Int) {
        self.cubesManager.unlockCubes(highScore)
    }
}
