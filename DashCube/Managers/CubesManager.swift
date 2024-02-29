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
    func setPlayerCubeAnimation(_ animation : CubeAnimation) {
        self.selectedPlayerCube.animation = animation
        // TODO: Save the animation in user defaults
    }
    
    func setPlayerCubeColor(_ color : Color) {
        self.selectedPlayerCube.color = color
        // TODO: Save the color to user defaults
    }
}

// MARK: - Get player cube values
private extension CubesManager {
    func getPlayerCubeAnimation() {
        // TODO: Get saved player cube animation from user defaults
    }
    
    func getPlayerCubeColor() {
        // TODO: Get saved player cube color from user defaults
    }
}
