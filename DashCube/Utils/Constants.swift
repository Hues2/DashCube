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
    struct Animation {
        static let playerMovementAnimationDuration : Double = 0.1
        static let jumpActionDuration : Double = 0.1
        static let jumpDisplayActionDuration : Double = 0.2
        static let rotationActionDuration : Double = 0.2
        static let pauseActionDuration : Double = 2.5
    }
    // MARK: - Node Name
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
        static let cubeIds = "cubeIds"
        static let selectedCubeId = "selectedCubeId"
    }
    // MARK: - Game Timer
    struct GameTimer {
        static let timerStartingSeconds : Int = 1
        static let timerStartingMilliSeconds : Int = 0
        static let timerMinimumMilliSeconds : Int = 59
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
            PlayerCube(color: .cube1,
                       animation: .basic,
                       requiredHighScore: .zero,
                       isUnlocked: true,
                       isSelected: false),
            PlayerCube(color: .cube2,
                       animation: .yAxisSpin,
                       requiredHighScore: 25,
                       isUnlocked: false,
                       isSelected: false),
            PlayerCube(color: .cube3,
                       animation: .basicWithYAxisSpin,
                       requiredHighScore: 50,
                       isUnlocked: false,
                       isSelected: false),
            PlayerCube(color: .cube4,
                       animation: .basicWithColorChange,
                       requiredHighScore: 50,
                       isUnlocked: false,
                       isSelected: false)
        ]
    }
    // MARK: - Game Center
    struct GameCenter {
        static let classicLeaderboard = "classicLeaderboard"
    }
}
