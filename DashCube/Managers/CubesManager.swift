import SwiftUI

class CubesManager {
    @Published var selectedPlayerCube : PlayerCube = PlayerCube(color: Color.cube1,
                                                          animation: .basic)
    
    func setPlayerCubeAnimation(_ animation : CubeAnimation) {
        self.selectedPlayerCube.animation = animation
        // TODO: Save the animation in user defaults
    }
    
    func setPlayerCubeColor(_ color : Color) {
        self.selectedPlayerCube.color = color
        // TODO: Save the color to user defaults
    }
}
