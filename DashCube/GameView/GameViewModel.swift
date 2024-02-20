import Foundation
import Combine
import SwiftUI

class GameViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    @Published private(set) var highscore : Int?
    @Published var isAnimating : Bool = false
    
    // Timer
    @Published private(set) var seconds : Int = 0
    @Published private(set) var milliseconds: Int = 0
    
    // Dependencies
    let gameManager : GameManager
    let cubesManager: CubesManager
    let gameCenterManager : GameCenterManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager, cubesManager: CubesManager, gameCenterManager : GameCenterManager) {
        self.gameManager = gameManager
        self.cubesManager = cubesManager
        self.gameCenterManager = gameCenterManager
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToScore()
        subscribeToHighScore()
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
                
                if newScore.isMultiple(of: 10) && newScore > 0 {
                    self.isAnimating.toggle()
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToHighScore() {
        self.gameCenterManager.$overallHighscore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighscore in
                guard let self, let newHighscore else { return }
                withAnimation {
                    self.highscore = newHighscore
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToGameState() {
        self.gameManager.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                withAnimation {
                    self.gameState = newGameState
                }
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
