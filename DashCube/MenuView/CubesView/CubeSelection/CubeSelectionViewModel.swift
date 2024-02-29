import Foundation

class CubeSelectionViewModel : ObservableObject {
    @Published private(set) var selectedPlayerCube : PlayerCube = PlayerCube(color: .cube1, animation: .basic)
    let animationCubes : [AnimationCube] = Constants.AnimationCubes.animationCubes
    
    // Dependencies
    private let cubesManager : CubesManager
    
    init(cubesManager : CubesManager) {
        self.cubesManager = cubesManager
    }
}
