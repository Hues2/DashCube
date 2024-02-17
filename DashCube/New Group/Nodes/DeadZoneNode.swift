import SceneKit

class DeadZoneNode: SCNNode {
    
    override init() {
        super.init()
        self.name = Constants.NodeName.deadZoneNodeName
        setUpPlatform()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpPlatform() {
        // Create a box geometry
        let boxGeometry = SCNBox(width: Constants.Node.deadZoneSize,
                                 height: Constants.Node.deadZoneHeight,
                                 length: Constants.Node.deadZoneSize,
                                 chamferRadius: 0.0)
        
        // Create a material for the box
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        
        // Apply the material to the box
        boxGeometry.materials = [material]
        
        // Create a node with the box geometry
        self.geometry = boxGeometry
        
        setUpPhysicsBody()
    }
    
    private func setUpPhysicsBody() {
        guard let geometry else { return }
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry))
        self.physicsBody?.categoryBitMask = Constants.Physics.deadZoneCategoryBitMask
        self.physicsBody?.collisionBitMask = Constants.Physics.playerCubeCategoryBitMask
        self.physicsBody?.contactTestBitMask = Constants.Physics.playerCubeCategoryBitMask
        self.physicsBody?.isAffectedByGravity = false        
    }
}
