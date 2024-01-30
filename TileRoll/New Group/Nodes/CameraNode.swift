import SceneKit

class CameraNode: SCNNode {
    let initialPosition : SCNVector3 = SCNVector3(x: 15, y: 15, z: 23)
    
    override init() {
        super.init()
        setUpCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCamera() {
        self.camera = SCNCamera()        
        let rotationAngle = SCNVector3Make(-0.3, 0.6, 0)
        self.eulerAngles = rotationAngle
    }
}
