import SceneKit

class TileNode: SCNNode, Identifiable {
    let id = UUID()
    var contactHandled : Bool = false
    let tilePosition : TilePosition
    
    init(tilePosition : TilePosition) {
        self.tilePosition = tilePosition
        super.init()
        self.name = Constants.tileNodeName
        setUpTile()
        addDeadZone()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTile() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.tileSize,
                                 height: Constants.tileSize,
                                 length: Constants.tileSize,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create a node with the box geometry
        self.geometry = boxGeometry
        
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.tileCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.playerCubeCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.playerCubeCategoryBitMask
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.friction = 1
    }
    
    private func addDeadZone() {
        let deadZone = DeadZoneNode()
        deadZone.position = self.position
        deadZone.position.y = self.position.y - 4
        self.addChildNode(deadZone)
    }
}
