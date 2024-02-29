import SwiftUI
import Combine

class CubeSelectionViewModel : ObservableObject {
    @Published private(set) var selectedPlayerCube : PlayerCube
    let animationCubes : [AnimationCube] = Constants.AnimationCubes.animationCubes
    let colorCubes : [ColorCube] = Constants.ColorCubes.colorCubes
    
    // Dependencies
    let cubesManager : CubesManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cubesManager : CubesManager) {
        self.cubesManager = cubesManager
        self.selectedPlayerCube = cubesManager.selectedPlayerCube
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        subscribeToSelectedPlayerCube()
    }
}

// MARK: - Subscribers
private extension CubeSelectionViewModel {
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
