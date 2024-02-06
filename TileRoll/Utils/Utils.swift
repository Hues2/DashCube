import Foundation
import SceneKit

class Utils {
    static let degreesPerRadians = Float(Double.pi / 180)
    static let radiansPerDegrees = Float(180 / Double.pi)

    static func toRadians(angle : Float) -> Float {
        return angle * degreesPerRadians
    }

    static func toRadians(angle : CGFloat) -> CGFloat {
        return angle * CGFloat(degreesPerRadians)
    }
    
    static func addNodeToScene(_ scene : SCNScene, _ node : SCNNode) {
        scene.rootNode.addChildNode(node)
    }
    
    static func randomBool(_ percentage: Double) -> Bool {
        if percentage > 100.0 { return true }
        if percentage < 0.0 { return false }
        let randomNumber = Double.random(in: 0.0...100.0)
        return randomNumber <= percentage
    }
}
