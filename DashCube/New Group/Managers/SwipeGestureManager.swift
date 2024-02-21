import SceneKit

class SwipeGestureManager {
    private let sceneView : SCNView
    private let playerCube : PlayerCubeNode
    private let gameManager : GameManager
    
    init(sceneView: SCNView, playerCube : PlayerCubeNode, gameManager : GameManager) {
        self.sceneView = sceneView
        self.playerCube = playerCube
        self.gameManager = gameManager
        addSwipeGestureRecognizer()
    }
    
    func addSwipeGestureRecognizer() {
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        rightSwipeGesture.direction = .right
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipeGesture.direction = .left
        self.sceneView.addGestureRecognizer(rightSwipeGesture)
        self.sceneView.addGestureRecognizer(leftSwipeGesture)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else { return }
        self.gameManager.startTimer()
//        self.enableSwipeGestureRecognizers(false)
        self.playerCube.swipeMove(gesture.direction) {
//            self.enableSwipeGestureRecognizers(true)
        }
    }
    
    func enableSwipeGestureRecognizers(_ isEnabled: Bool) {
        DispatchQueue.main.async {
            guard let gestures = self.sceneView.gestureRecognizers else { return }
            for gesture in gestures {
                gesture.isEnabled = isEnabled
            }
        }
    }
}
