import Foundation
import SceneKit

enum CubeAnimation {
    case basic
    case yAxisSpin
    case basicWithExtraRotation
    case basicWithYAxisSpin
    
    var displayAction : SCNAction {
        switch self {
        case .basic:
            return basicAction()
        case .yAxisSpin:
            return yAxisSpinAction()
        case .basicWithExtraRotation:
            return basicWithExtraRotationAction()
        case .basicWithYAxisSpin:
            return basicWithYAxisSpinAction()
        }
    }
    
    var cubeAction : CubeAction {
        switch self {
        case .basic:
            return basicCubeAction()
        case .yAxisSpin:
            return yAxisSpinCubeAction()
        case .basicWithExtraRotation:
            return basicWithExtraRotationCubeAction()
        case .basicWithYAxisSpin:
            return basicWithYAxisSpinCubeAction()
        }
    }
    
    struct CubeAction {
        let leftAction : SCNAction
        let rightAction : SCNAction
    }
}

// MARK: - Reusable Actions
extension CubeAnimation {
    func pauseAction() -> SCNAction {
        return SCNAction.move(by: .init(0, 0, 0), duration: Constants.Animation.pauseActionDuration)
    }
    
    func dispayJumpAction() -> SCNAction {
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: Constants.Animation.jumpDisplayActionDuration)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: Constants.Animation.jumpDisplayActionDuration)
        return SCNAction.sequence([jumpUpAction, jumpDownAction])
    }
    
    func jumpAction() -> SCNAction {
        let jumpUpAction = SCNAction.move(by: .init(0, 1, 0), duration: Constants.Animation.jumpActionDuration)
        let jumpDownAction = SCNAction.move(by: .init(0, -1, 0), duration: Constants.Animation.jumpActionDuration)
        return SCNAction.sequence([jumpUpAction, jumpDownAction])
    }
}

// MARK: - Basic Animation
extension CubeAnimation {
    private func basicAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = dispayJumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
    
    private func basicCubeAction() -> CubeAction {
        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        
        return CubeAction(leftAction: jumpLeftAndRotateAction, rightAction: jumpRightAndRotateAction)
    }
}

// MARK: - Y Axis Spin
extension CubeAnimation {
    private func yAxisSpinAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = dispayJumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(0, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, spinLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, spinRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
    
    private func yAxisSpinCubeAction() -> CubeAction {
        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Rotate left
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(0, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, spinLeftAction])
        
        // Rotate right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, spinRightAction])
        
        return CubeAction(leftAction: jumpLeftAndRotateAction, rightAction: jumpRightAndRotateAction)
    }
}

// MARK: - Basic Y Axis Spin
extension CubeAnimation {
    private func basicWithYAxisSpinAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = dispayJumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = .pi
        
        // Rotate & Spin left
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpAndSpinLeftAction = SCNAction.group([spinLeftAction, jumpAction])
        let leftAction = SCNAction.sequence([jumpAndSpinLeftAction, pauseAction])
        
        // Rotate & Spin right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpAndSpinRightAction = SCNAction.group([spinRightAction, jumpAction])
        let rightAction = SCNAction.sequence([jumpAndSpinRightAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
    
    private func basicWithYAxisSpinCubeAction() -> CubeAction {
        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = .pi
        
        // Rotate & Spin left
        let spinLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 1, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpAndSpinLeftAction = SCNAction.group([spinLeftAction, jumpAction])
        
        // Rotate & Spin right
        let spinRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 1, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpAndSpinRightAction = SCNAction.group([spinRightAction, jumpAction])
                
        return CubeAction(leftAction: jumpAndSpinLeftAction, rightAction: jumpAndSpinRightAction)
    }
}

// MARK: - Basic Animation
extension CubeAnimation {
    private func basicWithExtraRotationAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = dispayJumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = .pi
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let action = SCNAction.sequence([leftAction, rightAction])
        return .repeatForever(action)
    }
    
    private func basicWithExtraRotationCubeAction() -> CubeAction {
        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = .pi
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        
        return CubeAction(leftAction: jumpLeftAndRotateAction, rightAction: jumpRightAndRotateAction)
    }
}
