import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    private let gameCenterManager : GameCenterManager
    
    init() {
        self.gameManager = GameManager()
        self.cubesManager = CubesManager()
        self.gameCenterManager = GameCenterManager()
    }
    
    var body: some View {
        MainView(gameManager: gameManager,
                 cubesManager: cubesManager,
                 gameCenterManager : gameCenterManager)        
    }
}
