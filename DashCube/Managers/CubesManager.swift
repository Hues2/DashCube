import Foundation
import Combine

class CubesManager {
    @Published var cubes : [PlayerCube] = []
    @Published var selectedCube : PlayerCube = PlayerCube(color: .white,
                                                          animation: .basic,
                                                          requiredHighScore: .zero,
                                                          isUnlocked: false,
                                                          isSelected: false)
    
    // Dependencies
    let gameCenterManager : GameCenterManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(gameCenterManager : GameCenterManager) {
        self.gameCenterManager = gameCenterManager
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToHighScore()
    }
}

// MARK: - Subscriptions
private extension CubesManager {
    func subscribeToHighScore() {
        self.gameCenterManager.$overallHighScore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighScore in
                guard let self else { return }
                self.setUpCubes(newHighScore: newHighScore)
                self.setSelectedCube()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Cubes Setup
private extension CubesManager {
    func setUpCubes(newHighScore : Int?) {
        // High score
        let highScore = newHighScore ?? UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
        // Saved selected cube ID
        let savedSelectedCubeId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeId) as? String ?? ""
        // Set the cube values
        self.cubes = Constants.PlayerCubeValues.playerCubeOptions.map { cube in
            return PlayerCube(color: cube.color,
                              animation: cube.animation,
                              requiredHighScore: cube.requiredHighScore,
                              isUnlocked: (highScore >= cube.requiredHighScore), // Unlock the cubes that can be unlocked
                              isSelected: (savedSelectedCubeId == cube.id))      // Select the cube that has the matching ID
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
    
    func saveSelectedCube(_ id : String) {
        self.cubes = self.cubes.map { cube in
            return PlayerCube(color: cube.color,
                              animation: cube.animation,
                              requiredHighScore: cube.requiredHighScore,
                              isUnlocked: cube.isUnlocked,
                              isSelected: (id == cube.id))
        }
        self.setSelectedCube()
        UserDefaults.standard.setValue(id, forKey: Constants.UserDefaults.selectedCubeId)
    }
}
