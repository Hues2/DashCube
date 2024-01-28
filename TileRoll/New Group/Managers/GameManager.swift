import Foundation
import SceneKit

class GameManager {
    var score : Int = 0
}

extension GameManager {
    func addPoint() {
        self.score += 1
    }
}
