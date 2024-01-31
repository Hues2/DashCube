import SceneKit

class DeadZoneNode: SCNNode {
    
    override init() {
        super.init()
        self.name = Constants.deadZoneNodeName
        setUpPlatform()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpPlatform() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.deadZoneSize,
                                 height: Constants.deadZoneSize / 6,
                                 length: Constants.deadZoneSize,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create a node with the box geometry
        self.geometry = boxGeometry
        
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.deadZoneCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.playerCubeCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.playerCubeCategoryBitMask
        self.physicsBody?.isAffectedByGravity = false
        self.physicsBody?.friction = 1
    }
}
