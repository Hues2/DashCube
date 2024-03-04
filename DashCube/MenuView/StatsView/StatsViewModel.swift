import SwiftUI
import Combine

class StatsViewModel : ObservableObject {
    @Published private(set) var highScore : Int?
    @Published private(set) var gamesPlayed : Int?
    @Published private(set) var averageScore : Double?
    @Published private(set) var totalPoints : Int?
    
    // Dependencies
    let statsManager : StatsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ statsManager : StatsManager) {
        self.statsManager = statsManager
        // Set the values here, instead of giving them a default value
        // These values will get set via the combine subscriptions
        self.highScore = statsManager.highScore
        self.gamesPlayed = statsManager.gamesPlayed
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToHighScore()
        subscribeToGamesPlayed()
        subscribeToAverageScore()
        subscribeToTotalPoints()
    }
}

// MARK: - Subscribers
private extension StatsViewModel {
    func subscribeToHighScore() {
        self.statsManager.$highScore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighScore in
                guard let self else { return }
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
    
    func subscribeToAverageScore() {
        self.statsManager.$averageScore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAverageScore in
                guard let self else { return }
                self.averageScore = newAverageScore
            }
            .store(in: &cancellables)
    }
    
    func subscribeToTotalPoints() {
        self.statsManager.$totalPoints
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newTotalPoints in
                guard let self else { return }
                self.totalPoints = newTotalPoints
            }
            .store(in: &cancellables)
    }
}
