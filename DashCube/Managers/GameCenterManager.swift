import Foundation
import GameKit

class GameCenterManager {
    
}

extension GameCenterManager {
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }
}
