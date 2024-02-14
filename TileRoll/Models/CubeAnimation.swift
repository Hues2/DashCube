import Foundation
import SceneKit

enum CubeAnimation {
    case basic
    
    var action : SCNAction {
        switch self {
        case .basic:
            return basicAction()
        }
    }
    
    private func basicAction() -> SCNAction {
        // Pause
        let pauseAction = SCNAction.move(by: .init(0, 0, 0), duration: 3)
        
        // Jump
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: 0.2)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: 0.2)
        let jumpAction = SCNAction.sequence([jumpUpAction, jumpDownAction])
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: 0.2)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: 0.2)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
}
