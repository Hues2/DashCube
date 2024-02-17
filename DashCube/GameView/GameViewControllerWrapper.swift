import SwiftUI
import SceneKit

struct GameViewControllerWrapper: UIViewControllerRepresentable {
    let frameSize : CGSize
    let gameManager : GameManager
    let cubesManager: CubesManager
    let gameVC = GameViewController()
    
    func makeUIViewController(context: Context) -> GameViewController {
        gameVC.setUp(frameSize)
        gameVC.injectDependencies(gameManager: gameManager, cubesManager: cubesManager)
        return gameVC
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Update any properties of the view controller here
    }
}
