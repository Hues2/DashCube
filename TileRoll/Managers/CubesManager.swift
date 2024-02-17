import Foundation

class CubesManager {
    @Published var cubes : [PlayerCube] = []
    @Published var selectedCube : PlayerCube = PlayerCube(id: "white", color: .white, animation: .basic, cost: .zero, isUnlocked: false)
    
    // Dependencies
    private let cubeletsManager : CubeletsManager
    
    init(cubeletsManager : CubeletsManager) {
        self.cubeletsManager = cubeletsManager
        self.cubes = self.getUnlockedCubeIds()
        guard let savedSelectedCube = self.savedSelectedCube() else {
            guard let firstCube = Constants.PlayerCubeValues.playerCubeOptions.first else { return }
            self.selectedCube = firstCube
            return
        }
        self.selectedCube = savedSelectedCube
    }
}

// MARK: - Get unlocked cubes
private extension CubesManager {
    func getUnlockedCubeIds() -> [PlayerCube] {
        let unlockedIds = UserDefaults.standard.value(forKey: Constants.UserDefaults.cubeIds) as? [String] ?? []
        let cubes = Constants.PlayerCubeValues.playerCubeOptions.map { cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              cost: cube.cost,
                              isUnlocked: (unlockedIds.contains(cube.id)) ? true : cube.isUnlocked)
        }
        return cubes
    }
}

// MARK: - Unlock cube
extension CubesManager {
    func unlockCube(_ playerCube : PlayerCube) {
        // Save the cube id to user defaults
        var unlockedCubeIds : [String] = UserDefaults.standard.value(forKey: Constants.UserDefaults.cubeIds) as? [String] ?? []
        unlockedCubeIds.append(playerCube.id)
        UserDefaults.standard.setValue(unlockedCubeIds, forKey: Constants.UserDefaults.cubeIds)
        // Spend the cubelets
        self.cubeletsManager.spendCubelets(playerCube.cost)
        // Publish the modified cubes list
        self.cubes = self.cubes.map({ cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              cost: cube.cost,
                              isUnlocked: (playerCube == cube) ? true : cube.isUnlocked )
        })
    }
}

// MARK: - Selected cube
extension CubesManager {
    private func savedSelectedCube() -> PlayerCube? {
        let savedSelectedCubeId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeId) as? String
        return self.cubes.first(where: { $0.id == savedSelectedCubeId })
    }
    
    func saveSelectedCubeId(_ id : String) {
        UserDefaults.standard.setValue(id, forKey: Constants.UserDefaults.selectedCubeId)
    }
}
