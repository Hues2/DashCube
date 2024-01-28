import SceneKit

class CameraNode: SCNNode {
    let initialPosition : SCNVector3 = SCNVector3(x: 12, y: 12, z: 20)
    
    override init() {
        super.init()
        setUpCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCamera() {
        self.camera = SCNCamera()        
        let rotationAngle = SCNVector3Make(-0.1, 0.6, 0)
        self.eulerAngles = rotationAngle
    }
}
