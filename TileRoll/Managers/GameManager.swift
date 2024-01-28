import Foundation
import Combine

class GameManager {
    @Published private(set) var score : Int = 0
}

extension GameManager {
    func addPoint() {
        self.score += 1
    }
}
