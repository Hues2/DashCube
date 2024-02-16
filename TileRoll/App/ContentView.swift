import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let cubeletsManager : CubeletsManager
    private let gameManager : GameManager
    private let cubesManager : CubesManager
    
    init() {
        self.cubeletsManager = CubeletsManager()
        self.gameManager = GameManager(cubeletsManager: cubeletsManager)
        self.cubesManager = CubesManager(cubeletsManager: cubeletsManager)
    }
    
    var body: some View {
        MainView(gameManager: gameManager, cubeletsManager: cubeletsManager, cubesManager: cubesManager)
    }
}
