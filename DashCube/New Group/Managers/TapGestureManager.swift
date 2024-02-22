import Foundation
import SceneKit

class TapGestureManager {
    private let sceneView : SCNView
    private let playerCube : PlayerCubeNode
    private let gameManager : GameManager
    
    init(sceneView: SCNView, playerCube : PlayerCubeNode, gameManager : GameManager) {
        self.sceneView = sceneView
        self.playerCube = playerCube
        self.gameManager = gameManager
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))    
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        self.sceneView.addGestureRecognizer(rightTapGesture)
        self.sceneView.addGestureRecognizer(leftTapGesture)
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        self.gameManager.startTimer()
        self.enableTapGestureRecognizers(false)
        let location = recognizer.location(in: self.sceneView)
        if location.x < self.sceneView.bounds.width / 2 {
            self.playerCube.tapMove(.left) { self.enableTapGestureRecognizers(true) }
        } else {
            self.playerCube.tapMove(.right) { self.enableTapGestureRecognizers(true) }
        }
    }
    
    func enableTapGestureRecognizers(_ isEnabled: Bool) {
        DispatchQueue.main.async {
            guard let gestures = self.sceneView.gestureRecognizers else { return }
            for gesture in gestures {
                gesture.isEnabled = isEnabled
            }
        }
    }
    
    enum TapSide : CaseIterable {
        case left, right
    }
}
