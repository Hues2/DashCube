import UIKit
import QuartzCore
import SceneKit
import Combine

class GameViewController: UIViewController {
    // Size of the scene view
    private var viewSize : CGSize = .zero
    // Scene View
    private var sceneView : SCNView!
    // Scene
    private var scene : SCNScene!
    // Game Manager
    private var gameManager : GameManager!
    // Game Manager
    private var tileManager : TileManager!
    // Game Controller Manager;
    private var swipeGestureManager : SwipeGestureManager!
    // Camera
    private var cameraNode : CameraNode!
    // Player node
    private var playerCube : PlayerCubeNode!  
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    private var isFirstLoad : Bool = true
    // Game is reset
    private var gameIsReset : Bool = true
    // Game is over
    private var isGameOver : Bool = false
}

// MARK: - VC Setup
extension GameViewController {
    func setUp(_ size : CGSize) {
        self.viewSize = size
        setUpScene()
        setUpCamera()
        setUpPlayerCube()
        setUpTileManager()
        self.view.backgroundColor = .clear
        self.sceneView.backgroundColor = .clear
    }
    
    func injectDependencies(gameManager : GameManager) {
        self.gameManager = gameManager
        self.setUpSwipeGestureManager()
        self.addSubscriptions()
    }
}

// MARK: - Subscriptions
private extension GameViewController {
    private func addSubscriptions() {
        self.subscribeToGameState()
    }
    
    private func subscribeToGameState() {
        self.gameManager.$gameState        
            .sink { [weak self] newGameState in
                guard let self else { return }
                switch newGameState {
                case .menu :
                    self.resetGame()
                case .playing:
                    if !self.isFirstLoad {
                        self.resetGame()
                    }
                    self.isFirstLoad = false
                case .over:
                    self.gameIsReset = false
                    self.isGameOver = true
                    self.tileManager.gameOver()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Restart Game
private extension GameViewController {
    func resetGame() {
        if !self.gameIsReset {
            self.cameraNode.reset()
            self.tileManager.reset()
            self.playerCube.reset()
            self.isGameOver = false
            self.gameIsReset = true
        }
    }
}

// MARK: - Player Setup
private extension GameViewController {
    func setUpPlayerCube() {        
        self.playerCube = PlayerCubeNode()
        Utils.addNodeToScene(scene, playerCube)
    }
}

// MARK: - Camera Setup
private extension GameViewController {
    func setUpCamera() {
        self.cameraNode = CameraNode()
        self.cameraNode.position = cameraNode.initialPosition
        Utils.addNodeToScene(scene, cameraNode)
    }
}

// MARK: - Game Controller Manager Setup
private extension GameViewController {
    func setUpSwipeGestureManager() {
        self.swipeGestureManager = SwipeGestureManager(sceneView: self.sceneView,
                                                       playerCube: playerCube,
                                                       gameManager: self.gameManager)
    }
}

// MARK: - Game Manager Setup
private extension GameViewController {
    func setUpTileManager() {
        self.tileManager = TileManager(scene: self.scene, playerCube: self.playerCube)
    }
}

// MARK: - Scene & View Setup
extension GameViewController {
    func setUpScene() {
        sceneView = SCNView(frame: CGRect(origin: .zero, size: viewSize))
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.debugOptions = [.showPhysicsShapes, .showPhysicsFields, .showBoundingBoxes, .showSkeletons, .showWireframe]
//        self.sceneView.allowsCameraControl = true
        scene = SCNScene()
        sceneView.scene = scene
        scene.physicsWorld.contactDelegate = self
    }
}

// MARK: - Physics body collisions
extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Tile Node
        let tileNode = (contact.nodeA.name == Constants.NodeName.tileNodeName ? contact.nodeA : contact.nodeB) as? TileNode
        // Dead Zone Node
        let deadZoneNode = (contact.nodeA.name == Constants.NodeName.deadZoneNodeName ? contact.nodeA : contact.nodeB) as? DeadZoneNode
        // If there is contact with the dead zone then remove the dead zone and game over
        deadZoneNode?.removeFromParentNode()
        if let deadZoneNode, self.gameManager.gameState != .over, self.gameManager.gameState != .menu, !self.isGameOver {
            self.gameOver(deadZoneNode: deadZoneNode)
            return
        }
        
        // There has been contact between the player cube and a tile
        if let tileNode, !tileNode.contactHandled, gameManager.gameState == .playing {
            self.nextTile(tileNode: tileNode)
        }
        
        // Stop the player cube
        self.playerCube.stopPlayerCube()
    }
    
    private func nextTile(tileNode : TileNode) {
        tileNode.contactHandled = true
        self.tileManager.addNewTile(tileNode.id)
        self.gameManager.addPoint()
    }
    
    private func gameOver(deadZoneNode : DeadZoneNode) {
        self.gameManager.endGame()
        // Push player off screen
        self.playerCube.physicsBody?.applyForce(.init(0, -5, 0), asImpulse: true)
        self.isGameOver = true
    }
}

// MARK: - Scene Renderer
extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        self.updatePositions()
    }
    
// MARK: - Update Camera & Light Positions
    private func updatePositions() {
        if playerCube.position.y != playerCube.initialPlayerPosition.y {
            let x = playerCube.position.x + self.cameraNode.initialPosition.x
            let y = self.cameraNode.initialPosition.y - (playerCube.initialPlayerPosition.y - playerCube.position.y)
            let z = playerCube.position.z + self.cameraNode.initialPosition.z
            cameraNode.position = SCNVector3(x, y, z)
        }
    }
}
