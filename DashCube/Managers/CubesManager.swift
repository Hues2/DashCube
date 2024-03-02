import SwiftUI

class CubesManager {
    @Published var selectedPlayerCube : PlayerCube = PlayerCube(color: .cube1,
                                                                animation: .basic)
    init() {
        // Load saved animation and color
        self.getPlayerCubeAnimation()
        self.getPlayerCubeColor()
    }
}

// MARK: - Set player cube values
extension CubesManager {
    func changeSelectedAnimation(to animation : CubeAnimation) {
        // Avoid publishing the value if it hasn't changed
        if self.selectedPlayerCube.animation != animation {
            self.selectedPlayerCube.animation = animation
        }
        // Save to user defaults
        UserDefaults.standard.setValue(animation.rawValue, forKey: Constants.UserDefaults.selectedCubeAnimation)
    }
    
    func changeSelectedColor(to color : Color) {
        if self.selectedPlayerCube.color != color {
            self.selectedPlayerCube.color = color
        }
        
        UserDefaults.standard.setColor(color: UIColor(color), forKey: Constants.UserDefaults.selectedCubeColor)
    }
}

// MARK: - Get player cube values
private extension CubesManager {
    func getPlayerCubeAnimation() {
        let savedSelectedAnimationRawValue = UserDefaults.standard.string(forKey: Constants.UserDefaults.selectedCubeAnimation)
        guard let savedSelectedAnimationRawValue,
              let animation = CubeAnimation(rawValue: savedSelectedAnimationRawValue) else { return }
        self.selectedPlayerCube.animation = animation
    }
    
    func getPlayerCubeColor() {
        let savedSelectedColor = UserDefaults.standard.colorForKey(key: Constants.UserDefaults.selectedCubeColor)
        guard let savedSelectedColor else { return }
        self.selectedPlayerCube.color = Color(uiColor: savedSelectedColor)
    }
}
