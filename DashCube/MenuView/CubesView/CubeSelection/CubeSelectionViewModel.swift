import Foundation
import Combine

class CubeSelectionViewModel : ObservableObject {
    @Published private(set) var selectedPlayerCube : PlayerCube = PlayerCube(color: .cube1, animation: .basic)
    let animationCubes : [AnimationCube] = Constants.AnimationCubes.animationCubes
    
    // Dependencies
    private let cubesManager : CubesManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init(cubesManager : CubesManager) {
        self.cubesManager = cubesManager
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
            .sink { [weak self] newSelectedPlayerCube in
                guard let self else { return }
                self.selectedPlayerCube = newSelectedPlayerCube
            }
            .store(in: &cancellables)
    }
}

// MARK: - Change selected animation
extension CubeSelectionViewModel {
    func changeSelectedAnimation(to animation : CubeAnimation) {
        self.cubesManager.changeSelectedAnimation(to: animation)        
    }
}
