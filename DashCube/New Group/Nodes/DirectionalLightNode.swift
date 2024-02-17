import SceneKit

class DirectionalLightNode: SCNNode {
    let initialPosition : SCNVector3 = SCNVector3(x: 0, y: 15, z: 0)
    
    override init() {
        super.init()
        setUpLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLight() {        
        self.light = SCNLight()
        self.light?.type = .directional
        self.light?.intensity = 1000
        self.light?.color = UIColor.white.cgColor
        self.light?.castsShadow = true
        self.position = initialPosition
        let rotationAngle = SCNVector3Make(-1, 0, 0)
        self.eulerAngles = rotationAngle
    }
}
