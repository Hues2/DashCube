import Foundation
import Combine

class StatsManager : ObservableObject {
    @Published private(set) var highScore : Int?
    @Published private(set) var gamesPlayed : Int = .zero
    @Published private(set) var averageScore : Double = .zero
    @Published private(set) var totalPoints : Int = .zero
    
    private let gameCenterManager : GameCenterManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameCenterManager: GameCenterManager) {
        self.gameCenterManager = gameCenterManager
        self.getGamesPlayed()
        self.getTotalPoints()
        self.addSubscriptions()
    }
    
    func addSubscriptions() {
        self.subscribeToHighScore()
        self.setAverageScore()
    }
}

// MARK: - Subscriptions
private extension StatsManager {
    func subscribeToHighScore() {
        self.gameCenterManager.$overallHighscore
            .sink { [weak self] newHighScore in
                guard let self else { return }
                self.highScore = newHighScore
            }
            .store(in: &cancellables)
    }
    
    func setAverageScore() {
        self.$gamesPlayed
            .combineLatest(self.$totalPoints)
            .sink { [weak self] (newGamesPlayed, newTotalPoints) in
                guard let self else { return }
                self.calculateAverageScore(newTotalPoints, newGamesPlayed)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Games Played
extension StatsManager {
    private func getGamesPlayed() {
        self.gamesPlayed = UserDefaults.standard.integer(forKey: Constants.UserDefaults.gamesPlayed)
    }
    
    func addGamePlayed() {
        self.gamesPlayed += 1
        UserDefaults.standard.setValue(self.gamesPlayed, forKey: Constants.UserDefaults.gamesPlayed)
    }
}

// MARK: - Total Points
extension StatsManager {
    private func getTotalPoints() {
        self.totalPoints = UserDefaults.standard.integer(forKey: Constants.UserDefaults.totalPoints)
    }
    
    func addToTotalPoints(_ points : Int) {
        self.totalPoints += points
        UserDefaults.standard.setValue(self.totalPoints, forKey: Constants.UserDefaults.totalPoints)
    }
}

// MARK: - Average Score
private extension StatsManager {
    func calculateAverageScore(_ totalPoints : Int, _ gamesPlayed : Int) {
        guard totalPoints > 0 && gamesPlayed > 0 else { return }
        self.averageScore = Double(totalPoints) / Double(gamesPlayed)
    }
}
