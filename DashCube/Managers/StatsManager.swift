import Foundation
import Combine

class StatsManager : ObservableObject {
    @Published private(set) var highScore : Int?
    @Published private(set) var gamesPlayed : Int = .zero
    
    private let gameCenterManager : GameCenterManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameCenterManager: GameCenterManager) {
        self.gameCenterManager = gameCenterManager
        self.getGamesPlayed()
        self.addSubscriptions()
    }
    
    func addSubscriptions() {
        self.subscribeToHighScore()
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
}

// MARK: - Games Played
extension StatsManager {
    func getGamesPlayed() {
        self.gamesPlayed = UserDefaults.standard.integer(forKey: Constants.UserDefaults.gamesPlayed)
    }
    
    func addGamePlayed() {
        self.gamesPlayed += 1
        UserDefaults.standard.setValue(self.gamesPlayed, forKey: Constants.UserDefaults.gamesPlayed)
    }
}
