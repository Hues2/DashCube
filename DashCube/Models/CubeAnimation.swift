import Foundation
import SceneKit
import UIKit

enum CubeAnimation : String {
    case basic
    case yAxisSpin
    case basicWithYAxisSpin
    case basicWithColorChange
    
    var displayAction : SCNAction {
        switch self {
        case .basic:
            return displayBasicAction()
        case .yAxisSpin:
            return displayYAxisSpinAction()
        case .basicWithYAxisSpin:
            return displayBasicWithYAxisSpinAction()
        case .basicWithColorChange:
            return displayBasicWithColourChangeAction()
        }
    }
    
    var cubeAction : CubeAction {
        switch self {
        case .basic:
            return basicCubeAction()
        case .yAxisSpin:
            return yAxisSpinCubeAction()
        case .basicWithYAxisSpin:
            return basicWithYAxisSpinCubeAction()
        case .basicWithColorChange:
            return basicWithColourChangeCubeAction()
        }
    }
    
    struct CubeAction {
        let leftAction : SCNAction
        let rightAction : SCNAction
        var repeatForeverAction : SCNAction?
    }
}

// MARK: - Reusable Actions
private extension CubeAnimation {
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
    
    // Function to interpolate color between two UIColors
    func interpolateColor(from: UIColor, to: UIColor, fraction: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0, fromGreen: CGFloat = 0, fromBlue: CGFloat = 0, fromAlpha: CGFloat = 0
        var toRed: CGFloat = 0, toGreen: CGFloat = 0, toBlue: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        to.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let interpolatedRed = (1 - fraction) * fromRed + fraction * toRed
        let interpolatedGreen = (1 - fraction) * fromGreen + fraction * toGreen
        let interpolatedBlue = (1 - fraction) * fromBlue + fraction * toBlue
        let interpolatedAlpha = (1 - fraction) * fromAlpha + fraction * toAlpha
        
        return UIColor(red: interpolatedRed, green: interpolatedGreen, blue: interpolatedBlue, alpha: interpolatedAlpha)
    }
}

// MARK: - Basic Animation
extension CubeAnimation {
    private func displayBasicAction() -> SCNAction {
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
    private func displayYAxisSpinAction() -> SCNAction {
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
    private func displayBasicWithYAxisSpinAction() -> SCNAction {
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
private extension CubeAnimation {
    func displayBasicWithColourChangeAction() -> SCNAction {
        // Pause
        let pauseAction = pauseAction()

        // Jump
        let jumpAction = dispayJumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)
        
        // Change color action
        let changeColorAction = SCNAction.repeatForever(self.changeColorAction())
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        let leftAction = SCNAction.sequence([jumpLeftAndRotateAction, pauseAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        let rightAction = SCNAction.sequence([jumpRightAndRotateAction, pauseAction])
        
        // Action
        let rotationActions = SCNAction.sequence([leftAction, rightAction])
        let action = SCNAction.group([changeColorAction, rotationActions])
        return .repeatForever(action)
    }
    
    func basicWithColourChangeCubeAction() -> CubeAction {
        // Jump
        let jumpAction = jumpAction()
        
        // Rotation amount
        let rotationAmount : CGFloat = (.pi / 2)

        // Change color action
        let changeColorAction = self.changeColorAction()
        
        // Rotate left
        let rotateLeftAction = SCNAction.rotate(by: rotationAmount, around: .init(1, 0, 0), duration: Constants.Animation.rotationActionDuration)
        let jumpLeftAndRotateAction = SCNAction.group([jumpAction, rotateLeftAction])
        
        // Rotate right
        let rotateRightAction = SCNAction.rotate(by: -rotationAmount, around: .init(0, 0, 1), duration: Constants.Animation.rotationActionDuration)
        let jumpRightAndRotateAction = SCNAction.group([jumpAction, rotateRightAction])
        
        return CubeAction(leftAction: jumpLeftAndRotateAction, rightAction: jumpRightAndRotateAction, repeatForeverAction: changeColorAction)
    }
    
    func changeColorAction() -> SCNAction {
        // Original and target colors
        let originalColor = UIColor.cube4
        let targetColor1 = UIColor.cube1
        let targetColor2 = UIColor.cube2
        let targetColor3 = UIColor.cube3

        // Define the duration for each color change
        let colorChangeDuration = 0.7

        // Define the actions to change color and revert back
        let changeColorAction = SCNAction.customAction(duration: colorChangeDuration) { node, elapsedTime in
            let percentage = min(1.0, elapsedTime / CGFloat(colorChangeDuration))
            let newColor = self.interpolateColor(from: originalColor, to: targetColor1, fraction: percentage)
            node.geometry?.firstMaterial?.diffuse.contents = newColor
        }

        let revertColorAction1 = SCNAction.customAction(duration: colorChangeDuration) { node, elapsedTime in
            let percentage = min(1.0, elapsedTime / CGFloat(colorChangeDuration))
            let newColor = self.interpolateColor(from: targetColor1, to: targetColor2, fraction: percentage)
            node.geometry?.firstMaterial?.diffuse.contents = newColor
        }
        
        let revertColorAction2 = SCNAction.customAction(duration: colorChangeDuration) { node, elapsedTime in
            let percentage = min(1.0, elapsedTime / CGFloat(colorChangeDuration))
            let newColor = self.interpolateColor(from: targetColor2, to: targetColor3, fraction: percentage)
            node.geometry?.firstMaterial?.diffuse.contents = newColor
        }
        
        let revertColorAction3 = SCNAction.customAction(duration: colorChangeDuration) { node, elapsedTime in
            let percentage = min(1.0, elapsedTime / CGFloat(colorChangeDuration))
            let newColor = self.interpolateColor(from: targetColor3, to: originalColor, fraction: percentage)
            node.geometry?.firstMaterial?.diffuse.contents = newColor
        }

        return SCNAction.sequence([changeColorAction, revertColorAction1, revertColorAction2, revertColorAction3])
    }
}
