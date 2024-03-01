import SwiftUI
import Combine

class CubeSelectionViewModel : ObservableObject {
    // Cubes
    @Published private(set) var selectedPlayerCube : PlayerCube
    let animationCubes : [AnimationCube] = Constants.AnimationCubes.animationCubes
    let colorCubes : [ColorCube] = Constants.ColorCubes.colorCubes
    
    // Required stats
    @Published private(set) var highScore : Int = .zero
    
    // Dependencies
    let cubesManager : CubesManager
    let statsManager : StatsManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ cubesManager : CubesManager, _ statsManager : StatsManager) {
        self.cubesManager = cubesManager
        self.statsManager = statsManager
        self.selectedPlayerCube = cubesManager.selectedPlayerCube
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        self.subscribeToHighScore()
        self.subscribeToSelectedPlayerCube()
    }
}

// MARK: - Subscribers
private extension CubeSelectionViewModel {
    func subscribeToHighScore() {
        self.statsManager.$highScore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newHighScore in
                guard let self, let newHighScore else { return }
                self.highScore = newHighScore
            }
            .store(in: &cancellables)
    }
    
    func subscribeToSelectedPlayerCube() {
        self.cubesManager.$selectedPlayerCube
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newSelectedPlayerCube in
                guard let self else { return }
                self.selectedPlayerCube = newSelectedPlayerCube
            }
            .store(in: &cancellables)
    }
}

// MARK: - Change selected cube animation
extension CubeSelectionViewModel {
    func changeSelectedAnimation(to animation : CubeAnimation) {
        self.cubesManager.changeSelectedAnimation(to: animation)        
    }
}

// MARK: - Change selected cube color
extension CubeSelectionViewModel {
    func changeSelectedColor(to color : Color) {
        self.cubesManager.changeSelectedColor(to: color)
    }
}
