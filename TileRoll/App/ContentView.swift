import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    
    init() {
        self.gameManager = GameManager()
        self.cubesManager = CubesManager()
    }
    
    var body: some View {
        MainView(gameManager: gameManager, cubesManager: cubesManager)
    }
}
