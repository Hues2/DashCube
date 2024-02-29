import Foundation
import Combine
import SwiftUI

class MenuViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    @Published private(set) var highscore : Int?
    @Published private(set) var overallRank : Int?
    @Published private(set) var isGameOver : Bool = false
    
    // Player Cube
    @Published var selectedPlayerCube : PlayerCube
    
    // Dependencies
    let gameManager : GameManager
    let cubesManager: CubesManager
    let gameCenterManager : GameCenterManager
    
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager, cubesManager: CubesManager, gameCenterManager : GameCenterManager) {
        self.gameManager = gameManager
        self.cubesManager = cubesManager
        self.gameCenterManager = gameCenterManager
        self.selectedPlayerCube = cubesManager.selectedCube
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToScore()
        subscribeToGameState()
        subscribeToHighScore()
        subscribeToOverallRank()
    }
}

// MARK: - Subscribers
private extension MenuViewModel {
    func subscribeToScore() {
        self.gameManager.$score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newScore in
                guard let self else { return }
                self.score = newScore
            }
            .store(in: &cancellables)
    }
    
    func subscribeToGameState() {
        self.gameManager.$gameState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newGameState in
                guard let self else { return }
                self.gameState = newGameState
                self.isGameOver = ((newGameState == .over(timerEnded: true)) || (newGameState == .over(timerEnded: false)))
            }
            .store(in: &cancellables)
    }
    
    func subscribeToHighScore() {
        self.gameCenterManager.$overallHighscore
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] newHighscore in
                guard let self else { return }
                withAnimation {
                    self.highscore = newHighscore
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToOverallRank() {
        self.gameCenterManager.$overallRank
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] newOverallRank in
                guard let self else { return }
                withAnimation {
                    self.overallRank = newOverallRank
                }
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

// MARK: - Fetch Rank
extension MenuViewModel {
    func fetchOverallRank() {
        self.gameCenterManager.fetchOverallHighScoreAndRank()
    }
}
