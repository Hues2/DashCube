import Combine

class StatsManager : ObservableObject {
    @Published private(set) var highScore : Int?
    
    private let gameCenterManager : GameCenterManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameCenterManager: GameCenterManager) {
        self.gameCenterManager = gameCenterManager
        self.addSubscriptions()
    }
    
    func addSubscriptions() {
        self.subscribeToHighScore()
    }
}

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
