import UIKit
import QuartzCore
import SceneKit

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
}

// MARK: - VC Setup
extension GameViewController {
    func injectDependencies(gameManager : GameManager) {
        self.gameManager = gameManager
    }
    
    func setSize(_ size : CGSize) {
        self.viewSize = size
        setup()
    }
    
    private func setup() {
        setUpScene()
        setUpTileManager()
        setUpCamera()
        setUpPlayerCube()
        setUpSwipeGestureManager()
        self.view.backgroundColor = .clear
        self.sceneView.backgroundColor = .clear
    }
}

// MARK: - Player Setup
private extension GameViewController {
    func setUpPlayerCube() {
        let cubeXPosition = 0
        let cubeYPosition = 11
        let cubeZPosition = 0
        self.playerCube = PlayerCubeNode()
        playerCube.position = SCNVector3(cubeXPosition, cubeYPosition, cubeZPosition)
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
        self.swipeGestureManager = SwipeGestureManager(sceneView: self.sceneView, playerCube: playerCube)
    }
}

// MARK: - Game Manager Setup
private extension GameViewController {
    func setUpTileManager() {
        self.tileManager = TileManager(scene: self.scene)
    }
}

// MARK: - Scene & View Setup
extension GameViewController {
    func setUpScene() {
        sceneView = SCNView(frame: CGRect(origin: .zero, size: viewSize))
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.debugOptions = [.showPhysicsShapes, .showPhysicsFields]
        scene = SCNScene()
        sceneView.scene = scene
        scene.physicsWorld.contactDelegate = self
    }
}

// MARK: - Physics body collisions
extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let tileNode = (contact.nodeA.name == Constants.tileNodeName ? contact.nodeA : contact.nodeB) as? TileNode
        let deadZoneNode = (contact.nodeA.name == Constants.tileNodeName ? contact.nodeA : contact.nodeB) as? DeadZoneNode
        
        // If there is contact with the dead zone then game over
        if let deadZoneNode {
            self.gameManager.endGame()
            return
        }
        
        if let tileNode, !tileNode.contactHandled {
            tileNode.contactHandled = true
            self.tileManager.addNewTile()
            self.gameManager.addPoint()
        }
        
        // Stop the player cube
        self.playerCube.physicsBody?.velocity = SCNVector3Zero
        self.playerCube.physicsBody?.angularVelocity = SCNVector4Zero
    }
}

//MARK: - Scene Renderer
extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        updatePositions()
    }
    
//    MARK: - Update Camera & Light Positions
    private func updatePositions() {
        if playerCube.position.y != playerCube.initialPlayerY {
            let x = playerCube.position.x + self.cameraNode.initialPosition.x
            let y = self.cameraNode.initialPosition.y - (playerCube.initialPlayerY - playerCube.position.y)
            let z = playerCube.position.z + self.cameraNode.initialPosition.z
            cameraNode.position = SCNVector3(x, y, z)
        }
    }
}
