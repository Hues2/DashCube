import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameManager = GameManager()
    private let cubeletsManager = CubeletsManager()
    
    var body: some View {
        MainView(gameManager: gameManager, cubeletsManager: cubeletsManager)
    }
}
