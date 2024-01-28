import SwiftUI
import SceneKit

struct GameViewControllerWrapper: UIViewControllerRepresentable {
    let frameSize : CGSize
    let gameVC = GameViewController()
    func makeUIViewController(context: Context) -> GameViewController {
        gameVC.setSize(frameSize)
        return gameVC
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // Update any properties of the view controller here
    }
}
