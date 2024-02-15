import Foundation
import UIKit
import SwiftUI

class Constants {
    // MARK: - Node Values
    struct Node {
        static let rangeOfInitialNodes : ClosedRange<Int> = 0...2
        static let maxNumberOfTiles : Int = 8
        static let maxNumberOfSpikeTiles : Int = 8
        static let tileSize : Double = 2.0
        static let deadZoneSize : Double = 100
        static let deadZoneHeight : Double = 0.1
    }
    // MARK: - Animation
    static let playerMovementAnimationDuration : Double = 0.1
    struct NodeName {
        static let playerCubeNodeName = "player"
        static let tileNodeName = "tile"
        static let spikeTileNodeName = "spikeTile"
        static let deadZoneNodeName = "deadZone"
    }
    // MARK: - Physics
    struct Physics {
        static let playerCubeCategoryBitMask = 1
        static let tileCategoryBitMask = 2
        static let deadZoneCategoryBitMask = 2
    }
    // MARK: - UI
    struct UI {
        static let cornerRadius : CGFloat = 16
        static let outerMenuPadding : CGFloat = 20
        static let innerMenuPadding : CGFloat = 20
        static let horizontalMenuPadding : CGFloat = 10
    }
    // MARK: - SF Symbols
    struct SFSymbol {
        static let checkMark : String = "checkmark.seal.fill"
    }
    // MARK: - User Defaults
    struct UserDefaults {
        static let highScore = "highScore"
    }
    // MARK: - Game Timer
    struct GameTimer {
        static let timerStartingSeconds : Int = 2
        static let timerStartingMilliSeconds : Int = 0
        static let timerMinimumMilliSeconds : Int = 69
    }
    // MARK: - Namespace names
    struct GeometryEffectName {
        static let card = "card"
    }
    // Gameplay Values
    struct Gameplay {
        static let spikeTileOdds : Double = 25
    }
    // MARK: - Player Cube
    struct PlayerCubeValues {
        static let playerCubeOptions : [PlayerCube] = [
            PlayerCube(color: .red, animation: .basic),
            PlayerCube(color: .blue, animation: .yAxisSpin),
            PlayerCube(color: .purple, animation: .basic)
        ]
    }
}
