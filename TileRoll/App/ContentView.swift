import SwiftUI

struct ContentView: View {
    // Instantiate manager dependencies
    private let gameManager = GameManager()
    
    var body: some View {
        MainView(gameManager: gameManager)
    }
}
