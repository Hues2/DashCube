import Foundation
import SceneKit

enum CubeAnimation {
    case basic
    case yAxisSpin
    
    var action : SCNAction {
        switch self {
        case .basic:
            return basicAction()
        case .yAxisSpin:
            return yAxisSpinAction()            
        }
    }
}

// MARK: - Basic Animation
extension CubeAnimation {
    private func basicAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = jumpAction()
        
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

// MARK: - Y Axis Spin
extension CubeAnimation {
    private func yAxisSpinAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(0, 1, 0), duration: 0.2)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 0), duration: 0.2)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
}

// MARK: - Reusable Actions
extension CubeAnimation {
    func pauseAction() -> SCNAction {
        return SCNAction.move(by: .init(0, 0, 0), duration: 3)
    }
    
    func jumpAction() -> SCNAction {
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: 0.2)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: 0.2)
        return SCNAction.sequence([jumpUpAction, jumpDownAction])
    }
}
