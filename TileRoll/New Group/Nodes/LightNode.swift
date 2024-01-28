import SceneKit

class LightNode: SCNNode {
    override init() {
        super.init()
        setUpLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLight() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.intensity = 1000
        lightNode.light?.castsShadow = true
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        lightNode.eulerAngles = SCNVector3(x: .pi / 4, y: 5, z: 5)
        
        addChildNode(lightNode)
    }
}
