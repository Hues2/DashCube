import Foundation
import Combine
import SwiftUI

class GameViewModel : ObservableObject {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = .zero
    @Published private(set) var highScore : Int = .zero
    @Published var isAnimating : Bool = false
    
    // Timer
    @Published private(set) var seconds : Int = 0
    @Published private(set) var milliseconds: Int = 0
    
    // Dependencies
    let gameManager : GameManager
    let cubesManager: CubesManager
    let cubeletsManager: CubeletsManager
    private var cancellables = Set<AnyCancellable>()
    
    init(gameManager: GameManager, cubesManager: CubesManager, cubeletsManager: CubeletsManager) {
        self.gameManager = gameManager
        self.cubesManager = cubesManager
        self.cubeletsManager = cubeletsManager
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
        self.gameManager.$highScore
            .sink { [weak self] newHighScore in
                guard let self else { return }
                self.highScore = newHighScore
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
                self.handleGameStateCubelets(newGameState)
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

// MARK: - Cubelets
private extension GameViewModel {
    func handleGameStateCubelets(_ gameState : GameState) {
        switch gameState {
        case .playing:
            self.addCubelets(Constants.Cubelets.gameStartedCubelets)
        case .over(timerEnded: false):
            self.cubeletsManager.saveNewCubelets()
        default:
            break
        }
    }
    
    func addCubelets(_ amount : Int) {
        self.cubeletsManager.addCubelets(amount)
    }
}
