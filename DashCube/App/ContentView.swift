import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameCenterManager : GameCenterManager
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    private let statsManager : StatsManager
    
    init() {
        self.gameCenterManager = GameCenterManager()
        self.gameManager = GameManager(gameCenterManager : gameCenterManager)
        self.statsManager = StatsManager(gameCenterManager: gameCenterManager)
        self.cubesManager = CubesManager()
    }
    
    var body: some View {
        MainView(gameManager,
                 cubesManager,
                 gameCenterManager,
                 statsManager)
    }
}
