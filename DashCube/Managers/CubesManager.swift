import Combine
import UIKit

class CubesManager {
    @Published var cubes : [PlayerCube] = []
    @Published var selectedCube : PlayerCube = PlayerCube(color: .cube1,
                                                          animation: .basic,
                                                          requiredHighscore: .zero,
                                                          isUnlocked: true,
                                                          isSelected: false)
    @Published var cubeColors : [CubeColor] = []
    
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
        self.gameCenterManager.$overallHighscore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighscore in
                guard let self else { return }
                self.setUpCubes(newHighscore: newHighscore)
                self.setSelectedCube()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Cubes Setup
private extension CubesManager {
    func setUpCubes(newHighscore : Int?) {
        // Set up cube colors
        self.setUpCubeColors()
        // High score
        let highscore = newHighscore ?? UserDefaults.standard.integer(forKey: Constants.UserDefaults.highScore)
        // Saved selected cube ID
        let savedSelectedCubeId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeId) as? String ?? ""
        let savedSelectedCubeColorId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeColorId) as? String ?? ""
        let savedCubeColor = self.cubeColors.first(where: { $0.id == savedSelectedCubeColorId }) ?? .init(color: .cube1, isSelected: true)
        // Set the cube values
        self.cubes = Constants.PlayerCubeValues.playerCubeOptions.map { cube in
            return PlayerCube(color: UIColor(savedCubeColor.color),
                              animation: cube.animation,
                              requiredHighscore: cube.requiredHighscore,
                              isUnlocked: (highscore >= cube.requiredHighscore), // Unlock the cubes that can be unlocked
                              isSelected: (savedSelectedCubeId == cube.id))      // Select the cube that has the matching ID
        }
    }
    
    func setUpCubeColors() {
        let savedSelectedCubeId = UserDefaults.standard.value(forKey: Constants.UserDefaults.selectedCubeColorId) as? String ?? ""
        // Set the cube values
        self.cubeColors = Constants.PlayerCubeValues.colors.map { cubeColor in
            return CubeColor(color: cubeColor.color,
                             isSelected: (cubeColor.id == savedSelectedCubeId))
        }
    }
}

// MARK: - Selected cube
extension CubesManager {
    // This method is used to notify the game of any changes
    private func setSelectedCube() {
        let savedSelectedCube = self.cubes.first(where: { $0.isSelected })
        guard let savedSelectedCube else {
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
                              requiredHighscore: cube.requiredHighscore,
                              isUnlocked: cube.isUnlocked,
                              isSelected: (id == cube.id))
        }
        self.setSelectedCube()
        UserDefaults.standard.setValue(id, forKey: Constants.UserDefaults.selectedCubeId)
    }
}

// MARK: - Selected cube color
extension CubesManager {
    func saveSelectedCubeColor(_ selectedCubeColor : CubeColor) {
        // Set the selected value for the cube colors
        self.cubeColors = self.cubeColors.map({ cubeColor in
            return CubeColor(color: cubeColor.color,
                             isSelected: (cubeColor.id == selectedCubeColor.id))
        })
        
        // Change the color of the cubes
        self.cubes = self.cubes.map { cube in
            return PlayerCube(color: UIColor(selectedCubeColor.color),
                              animation: cube.animation,
                              requiredHighscore: cube.requiredHighscore,
                              isUnlocked: cube.isUnlocked,
                              isSelected: cube.isSelected)
        }
        
        // Publish the selected cube for the game scene
        self.setSelectedCube()
        
        // Saved the selected color
        UserDefaults.standard.setValue(selectedCubeColor.id, forKey: Constants.UserDefaults.selectedCubeColorId)
    }
}
