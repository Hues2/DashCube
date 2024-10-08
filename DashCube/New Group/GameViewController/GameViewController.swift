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
    // CubesManager
    private var cubesManager : CubesManager!
    // Game Manager
    private var tileManager : TileManager!
    // Swipe Gesture Manager
    private var swipeGestureManager : SwipeGestureManager!
    // Tap Gesture Manager
    private var tapGestureManager : TapGestureManager!
    // Camera
    private var cameraNode : CameraNode!
    // Directional Light
    private var directionalLightNode : DirectionalLightNode!
    // Ambient Light
    private var ambientLightNode : AmbientLightNode!
    // Player node
    private var playerCube : PlayerCubeNode!  
    // Cancellables
    private var cancellables = Set<AnyCancellable>()
    // Is first game load
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
        setUpAmbientLight()
        setUpDirectionalLight()
        setUpPlayerCube()
        setUpTileManager()
        self.view.backgroundColor = .clear
        self.sceneView.backgroundColor = .clear
    }
    
    func injectDependencies(gameManager : GameManager, cubesManager : CubesManager) {
        self.gameManager = gameManager
        self.cubesManager = cubesManager
        self.setUpSwipeGestureManager()
        self.setUpTapGestureManager()
        self.addSubscriptions()
    }
}

// MARK: - Subscriptions
private extension GameViewController {
    func addSubscriptions() {
        self.subscribeToGameState()
        self.subscribeToPlayerCubeModel()
    }
    
    func subscribeToGameState() {
        self.gameManager.$gameState        
            .sink { [weak self] newGameState in
                guard let self else { return }
                switch newGameState {
                case .menu:
                    self.resetGame()
                case .playing:
                    if !self.isFirstLoad {
                        self.resetGame()
                    }
                    self.isFirstLoad = false
                case .over(let timerEnded):
                    self.gameIsReset = false
                    self.isGameOver = true
                    self.tileManager.gameOver(timerEnded: timerEnded)
                }
            }
            .store(in: &cancellables)
    }
    
    func subscribeToPlayerCubeModel() {
        self.cubesManager.$selectedPlayerCube
            .sink { [weak self] newSelectedCube in
                guard let self else { return }
                self.playerCube.updatePlayerCubeModel(newSelectedCube)
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

// MARK: - Directional Light Setup
private extension GameViewController {
    func setUpDirectionalLight() {
        self.directionalLightNode = DirectionalLightNode()
        Utils.addNodeToScene(scene, directionalLightNode)
    }
}

// MARK: - Ambient Light Setup
private extension GameViewController {
    func setUpAmbientLight() {
        self.ambientLightNode = AmbientLightNode()
        Utils.addNodeToScene(scene, ambientLightNode)
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

// MARK: - Swipe Gesture Manager Setup
private extension GameViewController {
    func setUpSwipeGestureManager() {
        self.swipeGestureManager = SwipeGestureManager(sceneView: self.sceneView,
                                                       playerCube: playerCube,
                                                       gameManager: self.gameManager)
    }
}

// MARK: - Tap Gesture Manager Setup
private extension GameViewController {
    func setUpTapGestureManager() {
        self.tapGestureManager = TapGestureManager(sceneView: self.sceneView,
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
//        sceneView.debugOptions = [.showPhysicsShapes, .showPhysicsFields, .showBoundingBoxes, .showSkeletons, .showWireframe]
//        self.sceneView.allowsCameraControl = true
        scene = SCNScene()
        sceneView.scene = scene
        scene.physicsWorld.contactDelegate = self
    }
}

// MARK: - Physics body collisions
extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // Stop the player cube
        self.playerCube.stopPlayerCube()
        // Tile Node
        let tileNode = (contact.nodeA.name == Constants.NodeName.tileNodeName ? contact.nodeA : contact.nodeB) as? TileNode
        // Dead Zone Node
        let deadZoneNode = (contact.nodeA.name == Constants.NodeName.deadZoneNodeName ? contact.nodeA : contact.nodeB) as? DeadZoneNode
        // If there is contact with the dead zone then remove the dead zone and game over
        deadZoneNode?.removeFromParentNode()
        
        // MARK: - Player hit deadzone
        if deadZoneNode != nil,
           self.gameManager.gameState != .over(timerEnded: true),
           self.gameManager.gameState != .over(timerEnded: false),
           self.gameManager.gameState != .menu,
           !self.isGameOver {
            self.gameOver()
            return
        }
        
        // MARK: - Player hit spike node
        if let tileNode,
           tileNode.name == Constants.NodeName.spikeTileNodeName,
           self.gameManager.gameState != .over(timerEnded: true),
           self.gameManager.gameState != .over(timerEnded: false),
           self.gameManager.gameState != .menu,
           !self.isGameOver {
            tileNode.dropTile()
            self.gameOver()
            return
        }
        
        // MARK: - Player landed on tile
        if let tileNode,
           !tileNode.contactHandled,
           gameManager.gameState == .playing,
           tileNode.name == Constants.NodeName.tileNodeName {
            self.nextTile(tileNode: tileNode)
        }
    }
    
    // MARK: - Next Tile
    private func nextTile(tileNode : TileNode) {
        tileNode.contactHandled = true
        self.tileManager.addNewTile(tileNode.id)
        self.playerCube.adjustPositionToTile(tileNode)
        self.gameManager.addPoint()
    }
    
    // MARK: - Game Over
    private func gameOver() {
        self.gameManager.endGame()
        // Push player off screen
        self.playerCube.gameOver()
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
