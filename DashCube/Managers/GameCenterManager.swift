import Foundation
import GameKit
import Combine

/*
 entries.0 --> Local player leaderboard entry
 entries.1 --> List of player entries
 entries.2 --> Returns the total amount of entries in the leaderboard for the corresponding parameters (playerScope, timeScope, etc...)
 */

class GameCenterManager {
    @Published private(set) var isGameCenterEnabled : Bool = false
    @Published private(set) var overallHighScore : Int = .zero
    @Published private(set) var overallRank : Int = .zero
    @Published private(set) var dailyRank : Int = .zero
    
    private var leaderboards : [GKLeaderboard] = []
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
                    self.overallHighScore = self.getHighScoreFromAppStorage()
                    return
                }
                
                Task {
                    // Await this method, as the classic score and rank need the leaderboards to have returned
                    // Get leaderboards
                    await self.setLeaderboards()
                    // Set overall high score
                    await self.setOveralHighScore()
                    // Set overall rank
                    await self.setRank(Constants.GameCenter.classicLeaderboard)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Load all leaderboards
private extension GameCenterManager {
    func setLeaderboards() async  {
        let loadedLeaderboards = try? await GKLeaderboard.loadLeaderboards(IDs: [Constants.GameCenter.classicLeaderboard])
        guard let loadedLeaderboards else { return }
        self.leaderboards = loadedLeaderboards
    }
}

// MARK: - Get leaderboard entries
private extension GameCenterManager {
    func getLeaderboardEntries(from leaderboard : GKLeaderboard) async -> (GKLeaderboard.Entry?, [GKLeaderboard.Entry], Int)? {
        return try? await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10))
    }
}

// MARK: - Set classic high score
extension GameCenterManager {
    func setOveralHighScore() async {
        let classicLeaderboard = leaderboards.first(where: { $0.baseLeaderboardID == Constants.GameCenter.classicLeaderboard })
        guard let classicLeaderboard else {
            // There is no "classic" leaderboard
            self.overallHighScore = self.getHighScoreFromAppStorage()
            print("Classic leaderboard not found")
            return
        }
        
        // High score in app storage
        let appStorageHighScore = self.getHighScoreFromAppStorage()
        // High score in leaderboard
        let leaderboardHighScore = await self.getHighScoreFromLeaderboard(classicLeaderboard)
        // Sync the high scores
        self.syncHighScores(appStorageHighScore, leaderboardHighScore)
        // Publish the high score
        self.overallHighScore = max(leaderboardHighScore, appStorageHighScore)
    }
    
    private func getHighScoreFromLeaderboard(_ leaderboard : GKLeaderboard?) async -> Int {
        guard let leaderboard else { return 0 }
        let entries = await getLeaderboardEntries(from: leaderboard)
        return entries?.0?.score ?? 0
    }
    
    private func getHighScoreFromAppStorage() -> Int {
        return UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
    }
}

// MARK: - Sync high scores
private extension GameCenterManager {
    func syncHighScores(_ appStorageHighScore : Int, _ leaderboardHighScore : Int) {
        // If player played with no connection, the app storage high score may be higher than the leaderboard score
        if appStorageHighScore > leaderboardHighScore {
            self.saveHighScoreToGameCenterLeaderboard(appStorageHighScore)
        }
        // If it is first launch, the app storage value will be 0, but the game center leaderboard may have a score for this player already
        //So set the leaderboard score in the app storage
        else if leaderboardHighScore > appStorageHighScore {
            self.saveHighScoreToAppStorage(leaderboardHighScore)
        }
    }
}

// MARK: - Save new high score
extension GameCenterManager {
    func saveNewHighScore(_ score : Int) {
        self.overallHighScore = score
        self.saveHighScoreToAppStorage(score)
        self.saveHighScoreToGameCenterLeaderboard(score)
    }
    
    private func saveHighScoreToAppStorage(_ score : Int) {
        UserDefaults.standard.setValue(score, forKey: Constants.UserDefaults.highScore)
    }
    
    private func saveHighScoreToGameCenterLeaderboard(_ score : Int) {
        guard isGameCenterEnabled else { return }
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

// MARK: - Set Rank
private extension GameCenterManager {
    func setRank(_ leaderboardId : String) async {
        let leaderboard = self.leaderboards.first(where: { $0.baseLeaderboardID == leaderboardId })
        guard let leaderboard else { return }
        
        let leaderboardEntries = await self.getLeaderboardEntries(from: leaderboard)
        let rank = leaderboardEntries?.0?.rank
        guard let rank else { return }
        
        if leaderboardId == Constants.GameCenter.classicLeaderboard {
            self.overallRank = rank
        } else {
            self.dailyRank = rank
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
            self.isGameCenterEnabled = true
        }
    }
}
