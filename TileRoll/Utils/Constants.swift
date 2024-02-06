import Foundation
import SwiftUI

class Constants {
    static let rangeOfInitialNodes : ClosedRange<Int> = 0...2
    static let maxNumberOfTiles : Int = 8
    static let tileSize : Double = 2.0
    static let deadZoneSize : Double = 100
    static let deadZoneHeight : Double = 0.1
    // Animation
    static let playerMovementAnimationDuration : Double = 0.1
    // Physics
    static let playerCubeNodeName = "player"
    static let tileNodeName = "tile"
    static let spikeTileNodeName = "spikeTile"
    static let deadZoneNodeName = "deadZone"
    static let playerCubeCategoryBitMask = 1
    static let tileCategoryBitMask = 2
    static let spikeTileCategoryBitMask = 2
    static let deadZoneCategoryBitMask = 2
    // Colours
    struct Colour {
        static let pastelBlue : Color = Color(red: 0.686, green: 0.933, blue: 0.933)
        static let pastelPink : Color = Color(red: 1.0, green: 0.71, blue: 0.756)
    }
    // UI
    static let cornerRadius : CGFloat = 12
    // User Defaults
    struct UserDefaults {
        static let highScore = "highScore"
    }
    // Game Timer
    static let timerSeconds : Int = 6000
    static let timerMilliSeconds : Int = 0
    // Namespace names
    struct GeometryEffectName {
        static let card = "card"
    }
}
