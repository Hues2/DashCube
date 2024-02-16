import Foundation
import Combine

class CubeletsManager {
    @Published private(set) var totalCubelets : Int = .zero
    @Published private(set) var newCubelets : Int = .zero
    
    init() {
        self.getCubelets()
    }
}

// MARK: - Add cubelet
extension CubeletsManager {
    func addCubelets(_ amount : Int) {
        self.newCubelets += amount
    }
}

// MARK: - Get saved cubelets
extension CubeletsManager {
    func getCubelets() {
        self.totalCubelets = UserDefaults.standard.integer(forKey: Constants.UserDefaults.cubelets)
    }
}

// MARK: - Save new cubelets
extension CubeletsManager {
    func saveNewCubelets() {
        let newTotal = self.totalCubelets + self.newCubelets
        self.totalCubelets = newTotal
        self.newCubelets = .zero
        UserDefaults.standard.setValue(newTotal, forKey: Constants.UserDefaults.cubelets)
    }
}
