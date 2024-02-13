import Foundation
import SceneKit

enum CubeAnimation {
    case normal
    
    var action : SCNAction {
        switch self {
        case .normal:
            return normalAction()
        }
    }
    
    private func normalAction() -> SCNAction {
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: 0.2)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: 0.2)
        let pauseAction = SCNAction.move(by: .init(0, 0, 0), duration: 2)
        let jumpAction = SCNAction.sequence([jumpUpAction, jumpDownAction, pauseAction])
        return jumpAction
    }
}
