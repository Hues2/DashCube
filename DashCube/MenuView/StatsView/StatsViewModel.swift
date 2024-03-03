import SwiftUI
import Combine

class StatsViewModel : ObservableObject {
    @Published private(set) var highScore : Int
    @Published private(set) var gamesPlayed : Int
    
    // Dependencies
    let statsManager : StatsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ statsManager : StatsManager) {
        self.statsManager = statsManager
        // Set the values here, instead of giving them a default value
        // These values will get set via the combine subscriptions
        self.highScore = statsManager.highScore ?? .zero
        self.gamesPlayed = statsManager.gamesPlayed
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToHighScore()
        subscribeToGamesPlayed()
    }
}

// MARK: - Subscribers
private extension StatsViewModel {
    func subscribeToHighScore() {
        self.statsManager.$highScore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighScore in
                guard let self, let newHighScore else { return }
                self.highScore = newHighScore
            }
            .store(in: &cancellables)
    }
    
    func subscribeToGamesPlayed() {
        self.statsManager.$gamesPlayed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newGamesPlayed in
                guard let self else { return }
                self.gamesPlayed = newGamesPlayed
            }
            .store(in: &cancellables)
    }
}
