import SceneKit

class TileNode: SCNNode, Identifiable {
    let id = UUID()
    var contactHandled : Bool = false
    let tilePosition : TilePosition
    var collidedWith : Bool = false
    
    init(tilePosition : TilePosition) {
        self.tilePosition = tilePosition
        super.init()
        self.name = Constants.tileNodeName
        setUpTile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTile() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        
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
        self.physicsBody?.collisionBitMask = Constants.ballCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.ballCategoryBitMask
        self.physicsBody?.isAffectedByGravity = false
    }
}
