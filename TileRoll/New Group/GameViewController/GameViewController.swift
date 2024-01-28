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
    private var gameControllerManager : GameControllerManager!
    // Camera
    private var cameraNode : CameraNode!
    // Ball node
    private var ballNode : BallNode!
    private var previousBallY : Float = 12
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
        setUpBall()
        setUpGameControllerManager()
        self.view.backgroundColor = .clear
        self.sceneView.backgroundColor = .clear
    }
}

// MARK: - Tile Setup
private extension GameViewController {
    func setUpBall() {
        let ballXPosition = 0
        let ballYPosition = 12
        let ballZPosition = 0
        self.ballNode = BallNode()
        ballNode.position = SCNVector3(ballXPosition, ballYPosition, ballZPosition)
        Utils.addNodeToScene(scene, ballNode)
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
    func setUpGameControllerManager() {
        self.gameControllerManager = GameControllerManager(sceneView: self.sceneView, ballNode: self.ballNode)
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
        
        if let tileNode, !tileNode.contactHandled {
            tileNode.contactHandled = true
            self.tileManager.addNewTile()
            self.gameManager.addPoint()
        }
        
        // Stop the ball
        self.ballNode.physicsBody?.velocity = SCNVector3Zero
        self.ballNode.physicsBody?.angularVelocity = SCNVector4Zero
    }
}

//MARK: - Scene Renderer
extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        updatePositions()
    }
    
//    MARK: - Update Camera & Light Positions
    private func updatePositions() {
        if ballNode.position.y != previousBallY {
            let x = ballNode.position.x + self.cameraNode.initialPosition.x
            let y = self.cameraNode.initialPosition.y - (previousBallY - ballNode.position.y)
            let z = ballNode.position.z + self.cameraNode.initialPosition.z
            cameraNode.position = SCNVector3(x, y, z)
        }
    }
}
