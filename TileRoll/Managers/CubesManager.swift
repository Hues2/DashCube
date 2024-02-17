import Foundation

class CubesManager {
    @Published var cubes : [PlayerCube] = []
    @Published var selectedCube : PlayerCube = PlayerCube(id: "white",
                                                          color: .white,
                                                          animation: .basic,
                                                          requiredHighScore: .zero,
                                                          isUnlocked: false,
                                                          isSelected: false)
    
    init() {
        self.setCubes()
        self.setSelectedCube()
    }
}

// MARK: - Get unlocked cubes
private extension CubesManager {
    func setCubes() {
        // High score
        let highScore = UserDefaults.standard.value(forKey: Constants.UserDefaults.highScore) as? Int ?? 0
        // Saved selected cube ID
        let savedSelectedCubeId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeId) as? String ?? ""
        // Set the cube values
        self.cubes = Constants.PlayerCubeValues.playerCubeOptions.map { cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              requiredHighScore: cube.requiredHighScore,
                              isUnlocked: (highScore >= cube.requiredHighScore),
                              isSelected: (savedSelectedCubeId == cube.id))
        }        
    }
}

// MARK: - Unlock cube
extension CubesManager {
    func unlockCubes(_ highScore : Int) {
        self.cubes = self.cubes.map { cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              requiredHighScore: cube.requiredHighScore,
                              isUnlocked: (highScore >= cube.requiredHighScore),
                              isSelected: cube.isSelected)
        }
    }
}

// MARK: - Selected cube
extension CubesManager {
    private func setSelectedCube() {
        let savedSelectedCube = self.cubes.first(where: { $0.isSelected })
        guard let savedSelectedCube = savedSelectedCube else {
            guard let firstCube = Constants.PlayerCubeValues.playerCubeOptions.first else { return }
            self.selectedCube = firstCube
            return
        }
        self.selectedCube = savedSelectedCube
    }
    
    func saveSelectedCubeId(_ id : String) {
        guard let selectedCube = self.cubes.first(where: { $0.id == id }) else { return }
        self.cubes = self.cubes.map { cube in
            return PlayerCube(id: cube.id,
                              color: cube.color,
                              animation: cube.animation,
                              requiredHighScore: cube.requiredHighScore,
                              isUnlocked: cube.isUnlocked,
                              isSelected: (id == cube.id))
        }
        self.setSelectedCube()
        UserDefaults.standard.setValue(id, forKey: Constants.UserDefaults.selectedCubeId)
    }
}
