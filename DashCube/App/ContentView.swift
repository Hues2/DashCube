import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    private let gameCenterManager : GameCenterManager
    
    init() {
        self.gameCenterManager = GameCenterManager()
        self.gameManager = GameManager(gameCenterManager : gameCenterManager)
        self.cubesManager = CubesManager()
    }
    
    var body: some View {
        MainView(gameManager: gameManager,
                 cubesManager: cubesManager,
                 gameCenterManager : gameCenterManager)        
    }
}
