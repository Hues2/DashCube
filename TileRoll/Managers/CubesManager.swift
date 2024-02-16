import Foundation

class CubesManager {
    @Published var cubes : [PlayerCube] = Constants.PlayerCubeValues.playerCubeOptions
    
    // Dependencies
    private let cubeletsManager : CubeletsManager
    
    init(cubeletsManager : CubeletsManager) {
        self.cubeletsManager = cubeletsManager
    }
}

extension CubesManager {
    func unlockPlayerCube(_ playerCube : PlayerCube) {
        self.cubes = self.cubes.map({ cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              cost: cube.cost,
                              isUnlocked: (playerCube == cube) ? true : cube.isUnlocked )
        })
    }
}
