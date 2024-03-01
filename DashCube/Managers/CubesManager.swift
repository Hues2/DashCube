import SwiftUI

class CubesManager {
    @Published var selectedPlayerCube : PlayerCube = PlayerCube(color: .cube1,
                                                                animation: .basic)
    init() {
        getPlayerCubeAnimation()
        getPlayerCubeColor()
    }
}

// MARK: - Set player cube values
extension CubesManager {
    func changeSelectedAnimation(to animation : CubeAnimation) {
        // Avoid publishing the value if it hasn't changed
        if self.selectedPlayerCube.animation != animation {
            self.selectedPlayerCube.animation = animation
        }
        
        UserDefaults.standard.setValue(animation.rawValue, forKey: Constants.UserDefaults.selectedCubeAnimation)
    }
    
    func changeSelectedColor(to color : Color) {
        self.selectedPlayerCube.color = color
        // TODO: Save the color to user defaults
    }
}

// MARK: - Get player cube values
private extension CubesManager {
    func getPlayerCubeAnimation() {
        // TODO: Get saved player cube animation from user defaults
        let savedSelectedAnimationRawValue = UserDefaults.standard.string(forKey: Constants.UserDefaults.selectedCubeAnimation)
        guard let savedSelectedAnimationRawValue,
              let animation = CubeAnimation(rawValue: savedSelectedAnimationRawValue) else { return }
        self.selectedPlayerCube.animation = animation
    }
    
    func getPlayerCubeColor() {
        // TODO: Get saved player cube color from user defaults
    }
}
