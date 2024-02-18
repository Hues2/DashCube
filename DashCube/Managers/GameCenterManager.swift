import Foundation
import GameKit
import Combine

class GameCenterManager {
    @Published private(set) var gcEnabled : Bool = false
    @Published private(set) var gameCenterPlayers : [GameCenterPlayer] = []
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
                self.getUserHighScoreFromLeaderboard(self.classicLeaderboard)
            } catch {
                print("Classic leaderboard not found")
            }
        }
    }
}

// MARK: - Get user highscore
extension GameCenterManager {
    func getUserHighScoreFromLeaderboard(_ leaderboard : GKLeaderboard?) {
        guard let leaderboard else { return }
        leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10)) { local, entries, count, error in
            print("LOCAL PLAYER SCORE --> \(local?.formattedScore)")
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
                return
            }
            print("GAME CENTER ENABLED")
            print("LOCAL GAME PLAYER ID --> \(GKLocalPlayer.local.gamePlayerID)")
            print("LOCAL GAME PLAYER ALIAS --> \(GKLocalPlayer.local.alias)")
            print("LOCAL GAME PLAYER TEAM ID --> \(GKLocalPlayer.local.teamPlayerID)")
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
