import Foundation

import SceneKit

class AmbientLightNode: SCNNode {
    
    override init() {
        super.init()
        setUpLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLight() {
        self.light = SCNLight()
        self.light?.type = .ambient
        self.light?.color = UIColor.darkGray
    }
}
