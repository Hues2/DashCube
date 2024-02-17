import SceneKit

class TileNode: SCNNode, Identifiable {
    let id = UUID()
    var contactHandled : Bool = false
    let tilePosition : TilePosition
    var isFirstTile : Bool
    let isSpikeNode : Bool
    private var deadZoneNode : DeadZoneNode?
    
    init(tilePosition : TilePosition, isFirstTile : Bool, isSpikeNode : Bool) {
        self.tilePosition = tilePosition
        self.isFirstTile = isFirstTile
        self.isSpikeNode = isSpikeNode
        super.init()
        self.name = isSpikeNode ? Constants.NodeName.spikeTileNodeName : Constants.NodeName.tileNodeName
        setUpTile()
        if !isFirstTile && !isSpikeNode {
            addDeadZone()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTile() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.Node.tileSize,
                                 height: Constants.Node.tileSize,
                                 length: Constants.Node.tileSize,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = isSpikeNode ? UIColor.customDarkRed : UIColor.customDarkGray
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create a node with the box geometry
        self.geometry = boxGeometry
        
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody(_ type : SCNPhysicsBodyType = .kinematic) {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: type, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.Physics.tileCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.Physics.playerCubeCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.Physics.playerCubeCategoryBitMask
        self.physicsBody?.isAffectedByGravity = type == .kinematic ? false : true
        self.physicsBody?.friction = type == .kinematic ? 1 : 0
    }
    
    func updatePosition(position : SCNVector3) {
        self.position = position
    }
}

// MARK: - Dead Zone
extension TileNode {
    private func addDeadZone() {
        deadZoneNode = DeadZoneNode()
        guard let deadZoneNode else { return }
        deadZoneNode.position = self.position
        deadZoneNode.position.y = self.position.y - 1
        self.addChildNode(deadZoneNode)
    }
    
    func removeDeadZone() {
        guard let deadZoneNode else { return }
        deadZoneNode.removeFromParentNode()
    }
}

// MARK: - Drop Tile Node
extension TileNode {
    func dropTile() {
        self.setUpPhysicsBody(.dynamic)
        self.physicsBody?.applyForce(.init(0, -5, 0), asImpulse: true)
    }
}

// MARK: - Game Over
extension TileNode {
    func gameOver() {
        self.removeDeadZone()
    }
}
