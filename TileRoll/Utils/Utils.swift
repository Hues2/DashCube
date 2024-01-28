import Foundation
import SceneKit

class Utils {
    static let degreesPerRadians = Float(Double.pi / 180)
    static let radiansPerDegrees = Float(180 / Double.pi)

    static func randomBool(odds : Int) -> Bool {
        let random = arc4random_uniform(UInt32(odds))
        return random < 1 ? true : false
    }

    static func toRadians(angle : Float) -> Float {
        return angle * degreesPerRadians
    }

    static func toRadians(angle : CGFloat) -> CGFloat {
        return angle * CGFloat(degreesPerRadians)
    }
    
    static func addNodeToScene(_ scene : SCNScene, _ node : SCNNode) {
        scene.rootNode.addChildNode(node)
    }

    struct PhysicsCategory {
        static let chicken = 1
        static let vehicle = 2
        static let vegetation = 4
        static let collisionTestFront = 8
        static let collisionTestRight = 16
        static let collisionTestLeft = 32
    }
}
