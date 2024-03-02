import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameCenterManager : GameCenterManager
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    private let statsManager : StatsManager
    
    init() {
        self.gameCenterManager = GameCenterManager()
        self.statsManager = StatsManager(gameCenterManager: gameCenterManager)
        self.gameManager = GameManager(gameCenterManager, statsManager)
        self.cubesManager = CubesManager()
    }
    
    var body: some View {
        MainView(gameManager,
                 cubesManager,
                 gameCenterManager,
                 statsManager)
    }
}
