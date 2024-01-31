import Foundation
import SwiftUI

class Constants {
    static let rangeOfInitialNodes : ClosedRange<Int> = 0...7
    static let maxNumberOfTiles : Int = 16
    static let tileSize : Double = 2.0
    static let deadZoneSize : Double = 8.0
    
    // Animation
    static let playerMovementAnimationDuration : Double = 0.1
    
    // Physics
    static let playerCubeNodeName = "player"
    static let tileNodeName = "tile"
    static let deadZoneNodeName = "deadZone"
    static let playerCubeCategoryBitMask = 1
    static let tileCategoryBitMask = 2
    static let deadZoneCategoryBitMask = 2
    
    // Colours
    struct Colour {
        static let pastelBlue : Color = Color(red: 0.686, green: 0.933, blue: 0.933)
        static let pastelPink : Color = Color(red: 1.0, green: 0.71, blue: 0.756)
    }
    
    // UI
    static let cornerRadius : CGFloat = 12
}
