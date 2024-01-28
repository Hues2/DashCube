import Foundation
import Combine

class GameManager {
    @Published private(set) var score : Int = 0
}

extension GameManager {
    func addPoint() {
        DispatchQueue.main.async {
            self.score += 1
        }
    }
}
