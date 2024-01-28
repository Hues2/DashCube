import SceneKit

class BallNode: SCNNode {
    // Actions
    var jumpRightAction : SCNAction!
    var jumpLeftAction : SCNAction!
    
    override init() {
        super.init()
        self.name = Constants.ballNodeName
        setUpTile()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Movement
private extension BallNode {
    private func setUpTile() {
        // Create a sphere geometry
        let sphereGeometry = SCNSphere(radius: Constants.ballSize)
        
        // Create a material for the sphere
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        
        // Apply the material to the sphere
        sphereGeometry.materials = [material]
        
        // Set the geometry on the node
        self.geometry = sphereGeometry
        self.setUpPhysicsBody()
    }
    
    func setUpPhysicsBody() {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.ballCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.tileCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.tileCategoryBitMask
        self.physicsBody?.isAffectedByGravity = true
    }
}

// MARK: - Movement
extension BallNode {    
    func move(_ swipeDirection : UISwipeGestureRecognizer.Direction, _ completion : @escaping () -> Void) {
        switch swipeDirection {
        case .left:
            self.runAction(jumpLeftAction) {
                completion()
            }
        case .right:
            self.runAction(jumpRightAction) {
                completion()
            }
        default:
            break
        }
    }
    
    private func setupActions() {
        let moveUpAction = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0.2)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 0.2)
        moveUpAction.timingMode = .easeOut
        moveDownAction.timingMode = .easeIn
        let jumpAction = SCNAction.sequence([moveUpAction, moveDownAction])
        
        let moveRightAction = SCNAction.moveBy(x: 4, y: -2, z: 0, duration: 0.2)
        let moveLeftAction = SCNAction.moveBy(x: 0, y: -2, z: 4, duration: 0.2)
        
        self.jumpRightAction = SCNAction.group([jumpAction, moveRightAction])
        self.jumpLeftAction = SCNAction.group([jumpAction, moveLeftAction])
    }
}
