import Foundation
import Combine

class GameManager {
    @Published private(set) var gameState : GameState = .menu
    @Published private(set) var score : Int = 0
    @Published private(set) var highScore : Int = 0
    
    // Timer
    @Published private(set) var seconds : Int = Constants.GameTimer.timerSeconds
    @Published private(set) var milliseconds : Int = Constants.GameTimer.timerMilliSeconds
    @Published private(set) var timeEnded : Bool = false
    private var timer : Timer?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscriptions()
        getHighScore()
    }
    
    private func addSubscriptions() {
        subscribeToGameState()
        subscribeToTimerEnded()
    }
}

// MARK: - Subscriptions
private extension GameManager {
    func subscribeToGameState() {
        self.$gameState
            .sink { [weak self] newGameState in
                guard let self else { return }
                if newGameState == .over(timerEnded: true) || newGameState == .over(timerEnded: false) {
                    self.gameOver()
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToTimerEnded() {
        self.$timeEnded
            .sink { [weak self] timeHasEnded in
                guard let self,
                      timeHasEnded,
                      self.gameState != .over(timerEnded: true),
                      self.gameState != .over(timerEnded: false) else { return }
                self.gameState = .over(timerEnded: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Timer
extension GameManager {
    func startTimer() {
        DispatchQueue.main.async {
            self.stopTimer()
            self.timeEnded = false
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
                self.timeEnded = true
                stopTimer()
            }
        } else {
            milliseconds -= 1
        }
    }
    
    private func stopTimer() {
        self.seconds = Constants.GameTimer.timerSeconds
        self.milliseconds = Constants.GameTimer.timerMilliSeconds
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
        if self.gameState != .playing {
            DispatchQueue.main.async {
                self.score = 0
                self.gameState = .playing
            }
        }
    }
    
    func endGame() {
        if self.gameState != .over(timerEnded: true),
           self.gameState != .over(timerEnded: false) {
            DispatchQueue.main.async {
                self.gameState = .over(timerEnded: false)
            }
        }
    }
    
    func returnToMenu() {
        if self.gameState != .menu {
            DispatchQueue.main.async {
                self.gameState = .menu
            }
        }
    }
}

// MARK: - Game over
private extension GameManager {
    func gameOver() {
        self.stopTimer()
        self.setHighScore()
    }
}
