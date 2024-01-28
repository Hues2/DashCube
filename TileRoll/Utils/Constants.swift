import Foundation
import SwiftUI

class Constants {
    static let rangeOfInitialNodes : ClosedRange<Int> = 0...7
    static let maxNumberOfTiles : Int = 16
    static let tileSize : Double = 2.0
    static let ballSize : Double = 1.0
    
    // Physics
    static let tileNodeName = "tile"
    static let ballNodeName = "ball"
    static let ballCategoryBitMask = 1
    static let tileCategoryBitMask = 2
    
    // Colours
    struct Colour {
        static let pastelBlue : Color = Color(red: 0.686, green: 0.933, blue: 0.933)
        static let pastelPink : Color = Color(red: 1.0, green: 0.71, blue: 0.756)
    }
}
