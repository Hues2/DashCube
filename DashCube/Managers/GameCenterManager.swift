import Foundation
import GameKit
import Combine

class GameCenterManager {
    @Published private(set) var isGameCenterEnabled : Bool = false
    @Published private(set) var highScore : Int = 0
    
    // Leaderboards
    private var classicLeaderboard : GKLeaderboard?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.addSubscriptions()
        self.authenticateUser()
    }
    
    func addSubscriptions() {
        subscribeToGameCenterEnabled()
    }
}

// MARK: - Subscribers
private extension GameCenterManager {
    func subscribeToGameCenterEnabled() {
        self.$isGameCenterEnabled
            .dropFirst()
            .sink { [weak self] newIsGameCenterEnabled in
                guard let self else { return }
                guard newIsGameCenterEnabled else {
                    self.setSavedHighScore(nil)
                    return
                }
                self.loadClassicLeaderboard()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Load classic leaderboard
extension GameCenterManager {
    func loadClassicLeaderboard() {
        print("GAME CENTER --> Loading Classic Leaderboard")
        Task {
            do {
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [Constants.GameCenter.classicLeaderboard])
                self.classicLeaderboard = leaderboards.first
                self.setSavedHighScore(classicLeaderboard)
            } catch {
                self.highScore = self.getUserHighScoreFromAppStorage()
                print("Classic leaderboard not found")
            }
        }
    }
}

// MARK: - Get user highscore
extension GameCenterManager {
    func setSavedHighScore(_ leaderboard : GKLeaderboard?) {
        print("GAME CENTER --> Getting saved high score")
        let appStorageHighScore = self.getUserHighScoreFromAppStorage()
        Task {
            let leaderboardHighScore = await self.getUserHighScoreFromLeaderboard(leaderboard)
            self.highScore = max(leaderboardHighScore, appStorageHighScore)
        }
        // TODO: If the app storage high score is higher than the leaderboard score, then set this score in the game center leaderboard --> If game center is enabled
    }
    
    // MARK: - Leaderboard High Score
    func getUserHighScoreFromLeaderboard(_ leaderboard : GKLeaderboard?) async -> Int {
        guard let leaderboard else { return 0 }
        let entries = try? await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10))
        return entries?.0?.score ?? 0
    }
    
    // MARK: - App Storage High Score
    func getUserHighScoreFromAppStorage() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
    }
}

// MARK: - Set high score
extension GameCenterManager {
    func setNewHighScore(_ score : Int) {
        print("GAME CENTER --> Setting new high score")
        self.highScore = score
        UserDefaults.standard.setValue(score, forKey: Constants.UserDefaults.highScore)
        guard isGameCenterEnabled else { return }
        // Game center is enabled
        // Save the new highscore
        Task {
            try? await GKLeaderboard.submitScore(score,
                                                 context: 0,
                                                 player: GKLocalPlayer.local,
                                                 leaderboardIDs: [Constants.GameCenter.classicLeaderboard])
            /*
             If the high score couldn't be saved to the game center leaderboard,
             it has been saved to the app storage and can be attempted to be saved
             to the leaderboard again when a new high score has been set
             */
        }
    }
}

// MARK: - Authenticate User
extension GameCenterManager {
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { _, error in
            guard error == nil else {
                // TODO: Handle error case
                print(error?.localizedDescription ?? "")
                self.isGameCenterEnabled = false
                return
            }
            print("GAME CENTER ENABLED")
            self.isGameCenterEnabled = true
        }
    }
}

extension GameCenterManager {
    struct GameCenterPlayer {
        let name : String
        let score : Int
    }
}
