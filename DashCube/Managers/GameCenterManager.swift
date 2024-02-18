import Foundation
import GameKit
import Combine

class GameCenterManager {
    @Published private(set) var gcEnabled : Bool = false
    @Published private(set) var gameCenterPlayers : [GameCenterPlayer] = []
    
    init() {
        self.authenticateUser()
    }
}

// MARK: - Load Leaderboards
extension GameCenterManager {
    func loadLeaderboards() {
        Task {
            do {
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: nil)
                print("LEADERBOARDS: \(leaderboards)")
            } catch {
                print("NO LEADERBOARD")
            }
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
            self.loadLeaderboards()
        }
    }
}

extension GameCenterManager {
    struct GameCenterPlayer {
        let name : String
        let score : Int
    }
}
