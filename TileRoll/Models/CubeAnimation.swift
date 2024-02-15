import Foundation
import SceneKit

enum CubeAnimation {
    case basic
    case yAxisSpin
    case basicYAxisSpin
    
    var action : SCNAction {
        switch self {
        case .basic:
            return basicAction()
        case .yAxisSpin:
            return yAxisSpinAction()
        case .basicYAxisSpin:
            return basicYAxisSpinAction()
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
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(0, 1, 0), duration: 0.2)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, spinLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 0), duration: 0.2)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, spinRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
}

// MARK: - Basic Y Axis Spin
extension CubeAnimation {
    private func basicYAxisSpinAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = .pi
        
        // Rotate & Spin left
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 1, 0), duration: 0.4)
        let jumpAndSpinLeftAction = SCNAction.group([spinLeftAction, jumpAction])
        let leftAction = SCNAction.sequence([jumpAndSpinLeftAction, pauseAction])
        
        // Rotate & Spin right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 1), duration: 0.4)
        let jumpAndSpinRightAction = SCNAction.group([spinRightAction, jumpAction])
        let rightAction = SCNAction.sequence([jumpAndSpinRightAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
}

// MARK: - Reusable Actions
extension CubeAnimation {
    func pauseAction() -> SCNAction {
        return SCNAction.move(by: .init(0, 0, 0), duration: 1)
    }
    
    func jumpAction() -> SCNAction {
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: 0.2)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: 0.2)
        return SCNAction.sequence([jumpUpAction, jumpDownAction])
    }
}
