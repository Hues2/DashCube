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
    
    func setSize(_ size : CGSize) {
        self.viewSize = size
        setup()
    }
    
    private func setup() {
        setUpScene()
        setUpGameManager()
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
    func setUpGameManager() {
        self.gameManager = GameManager()
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
        setSceneBackground()
    }
    
    func setSceneBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let startColor = UIColor(red: 1.0, green: 0.71, blue: 0.756, alpha: 1).cgColor // Pastel Pink
        let endColor = UIColor(red: 0.686, green: 0.933, blue: 0.933, alpha: 1).cgColor // Pastel Blue
        
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
//        scene.background.contents = gradientLayer
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
