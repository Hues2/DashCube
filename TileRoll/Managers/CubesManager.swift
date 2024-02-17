import Foundation

class CubesManager {
    @Published var cubes : [PlayerCube] = []
    @Published var selectedCube : PlayerCube = PlayerCube(id: "white", color: .white, animation: .basic, cost: .zero, isUnlocked: false)
    
    init() {
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
        // TODO: Should use CloudKit or similar to store this data, instead of user defaults
        // Save the cube id to user defaults
        var unlockedCubeIds : [String] = UserDefaults.standard.value(forKey: Constants.UserDefaults.cubeIds) as? [String] ?? []
        unlockedCubeIds.append(playerCube.id)
        UserDefaults.standard.setValue(unlockedCubeIds, forKey: Constants.UserDefaults.cubeIds)        
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
        guard let cube = self.cubes.first(where: { $0.id == id }) else { return }
        self.selectedCube = cube
        UserDefaults.standard.setValue(id, forKey: Constants.UserDefaults.selectedCubeId)
    }
}
