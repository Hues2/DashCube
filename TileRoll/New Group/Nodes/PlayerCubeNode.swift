import SceneKit

class PlayerCubeNode: SCNNode {
    // Actions
    private var jumpRightAction : SCNAction!
    private var jumpLeftAction : SCNAction!
    private let initialRotation = SCNVector4(x: 0, y: 0, z: 0, w: 0)
    let initialPlayerPosition : SCNVector3 = SCNVector3(0, 12, 0)
    
    override init() {
        super.init()
        self.name = Constants.playerCubeNodeName
        setUpCube()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Movement
private extension PlayerCubeNode {
    private func setUpCube() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.tileSize,
                                 height: Constants.tileSize,
                                 length: Constants.tileSize,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create a node with the box geometry
        self.geometry = boxGeometry
        
        // Set the position of the player cube
        self.position = initialPlayerPosition
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.playerCubeCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.tileCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.tileCategoryBitMask
        self.physicsBody?.isAffectedByGravity = true
        self.physicsBody?.friction = 1
    }
}

// MARK: - Movement
extension PlayerCubeNode {
    func move(_ swipeDirection : UISwipeGestureRecognizer.Direction, _ completion : @escaping () -> Void) {
        switch swipeDirection {
        case .left:
            self.rotation = initialRotation
            self.runAction(jumpLeftAction) {
                completion()
            }
        case .right:
            self.rotation = initialRotation
            self.runAction(jumpRightAction) {
                completion()
            }
        default:
            break
        }
    }
    
    private func setupActions() {
        let duration = Constants.playerMovementAnimationDuration
        
        self.jumpRightAction = SCNAction.group([jumpAction(duration),
                                                rotateAction(duration, .right),
                                                moveAction(duration, .right)])
        self.jumpLeftAction = SCNAction.group([jumpAction(duration),
                                               rotateAction(duration, .left),
                                               moveAction(duration, .left)])
    }
}

// MARK: - Animation
private extension PlayerCubeNode {
    func jumpAction(_ duration : Double) -> SCNAction {
        let moveUpAction = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: duration)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: duration)
        moveUpAction.timingMode = .easeOut
        moveDownAction.timingMode = .easeIn
                
        return SCNAction.sequence([moveUpAction, moveDownAction])
    }
    
    func rotateAction(_ duration : Double, _ direction : UISwipeGestureRecognizer.Direction) -> SCNAction {
        switch direction {
        case .right:
            let rightRotationAmount : CGFloat = -(.pi / 2)
            return SCNAction.rotateBy(x: 0, y: 0, z: rightRotationAmount, duration: duration)
        case .left:
            let leftRotationAmount : CGFloat = (.pi / 2)
            return SCNAction.rotateBy(x: leftRotationAmount, y: 0, z: 0, duration: duration)
        default:
            return SCNAction()
        }
    }
    
    func moveAction(_ duration : Double, _ direction : UISwipeGestureRecognizer.Direction) -> SCNAction {
        switch direction {
        case .right:
            return SCNAction.moveBy(x: 4, y: -2, z: 0, duration: duration)
        case .left:
            return SCNAction.moveBy(x: 0, y: -2, z: 4, duration: duration)
        default:
            return SCNAction()
        }
    }
}

// MARK: - Stop Player Cube
extension PlayerCubeNode {
    func stopPlayerCube() {
        self.physicsBody?.velocity = SCNVector3Zero
        self.physicsBody?.angularVelocity = SCNVector4Zero
    }
}

// MARK: - Reset
extension PlayerCubeNode {
    func reset() {        
        self.stopPlayerCube()
        self.position = self.initialPlayerPosition
        self.rotation = self.initialRotation
    }
}
