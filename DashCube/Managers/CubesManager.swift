import Combine
import UIKit

class CubesManager {
    @Published var selectedCube : PlayerCube = PlayerCube(color: .cube1,
                                                          animation: .basic)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.addSubscriptions()
    }
    
    private func addSubscriptions() {
        
    }
}
