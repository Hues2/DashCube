import Foundation
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
    // MARK: - Colours
    struct Colour {
        static let pastelBlue : Color = Color(red: 0.686, green: 0.933, blue: 0.933)
        static let pastelPink : Color = Color(red: 1.0, green: 0.71, blue: 0.756)
    }
    // MARK: - UI
    struct UI {
        static let cornerRadius : CGFloat = 16
        static let outerMenuPadding : CGFloat = 20
        static let innerMenuPadding : CGFloat = 20
        static let horizontalMenuPadding : CGFloat = 10
    }
    // MARK: - User Defaults
    struct UserDefaults {
        static let highScore = "highScore"
    }
    // MARK: - Game Timer
    struct GameTimer {
        static let timerSeconds : Int = 60
        static let timerMilliSeconds : Int = 0
    }
    // MARK: - Namespace names
    struct GeometryEffectName {
        static let card = "card"
    }
    // Gameplay Values
    struct Gameplay {
        static let spikeTileOdds : Double = 20
    }
}
