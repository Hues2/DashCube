import Foundation
import GameKit
import Combine

class GameCenterManager {
    @Published private(set) var gcEnabled : Bool = false
    @Published private(set) var highScore : Int = 0
    
    // Leaderboards
    private var classicLeaderboard : GKLeaderboard?
    
    init() {
        self.authenticateUser()
    }
}

// MARK: - Load classic leaderboard
extension GameCenterManager {
    func loadClassicLeaderboard() {
        Task {
            do {
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [Constants.GameCenter.classicLeaderboard])
                self.classicLeaderboard = leaderboards.first
                self.setHighScore(classicLeaderboard)
            } catch {
                self.highScore = self.getUserHighScoreFromAppStorage()
                print("Classic leaderboard not found")
            }
        }
    }
}

// MARK: - Get user highscore
extension GameCenterManager {
    func setHighScore(_ leaderboard : GKLeaderboard?) {
        self.highScore = max(self.getUserHighScoreFromLeaderboard(leaderboard),
                             self.getUserHighScoreFromAppStorage())
    }
    
    func getUserHighScoreFromLeaderboard(_ leaderboard : GKLeaderboard?) -> Int {
        var score : Int = .zero
        leaderboard?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10)) { local, entries, count, error in
            print("LOCAL PLAYER SCORE --> \(local?.formattedScore)")
            score = local?.score ?? 0
        }
        return score
    }
    
    func getUserHighScoreFromAppStorage() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
    }
}

// MARK: - Authenticate User
extension GameCenterManager {
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { _, error in
            guard error == nil else {
                // TODO: Handle error case
                print(error?.localizedDescription ?? "")
                return
            }
            print("GAME CENTER ENABLED")
            print("LOCAL GAME PLAYER ALIAS --> \(GKLocalPlayer.local.alias)")
            self.gcEnabled = true
            self.loadClassicLeaderboard()
        }
    }
}

extension GameCenterManager {
    struct GameCenterPlayer {
        let name : String
        let score : Int
    }
}
