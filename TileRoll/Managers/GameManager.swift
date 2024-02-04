import Foundation
import Combine

class GameManager {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = 0
    @Published private(set) var highScore : Int = 0
    
    // Timer
    @Published private(set) var seconds: Int = 5
    @Published private(set) var milliseconds: Int = 0
    @Published private(set) var timeEnded : Bool = false
    private var timer : Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriptions()
        getHighScore()
    }
    
    private func addSubscriptions() {
        subscribeToGameState()
    }
}

// MARK: - Subscriptions
private extension GameManager {
    func subscribeToGameState() {
        self.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                if newGameState == .over {
                    self.setHighScore()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Timer
extension GameManager {
    func startTimer() {
        DispatchQueue.main.async {
            self.timeEnded = false
            self.seconds = 5
            self.milliseconds = 0
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
                guard let self else { return }
                self.updateTimer()
            }
        }
    }
    
    private func updateTimer() {
        if milliseconds == 0 {
            if seconds > 0 {
                self.seconds -= 1
                self.milliseconds = 99
            } else {
                stopTimer()
            }
        } else {
            milliseconds -= 1
        }
    }
    
    private func stopTimer() {
        self.timeEnded = true
        print("TIME OUT!!!")
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - High Score
extension GameManager {
    private func getHighScore() {
        self.highScore = UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
    }
    
    private func setHighScore() {
        if self.score > self.highScore {
            self.highScore = score
            UserDefaults.standard.setValue(score, forKey: Constants.UserDefaults.highScore)
        }
    }
}

// MARK: - Points
extension GameManager {
    func addPoint() {
        DispatchQueue.main.async {
            self.score += 1
        }
    }
}

// MARK: - Start/End Game & Back to menu
extension GameManager {
    func startGame() {
        DispatchQueue.main.async {
            self.score = 0
            self.gameState = .playing
        }
    }
    
    func endGame() {
        DispatchQueue.main.async {
            self.gameState = .over
        }
    }
    
    func returnToMenu() {
        DispatchQueue.main.async {
            self.gameState = .menu
        }
    }
}
