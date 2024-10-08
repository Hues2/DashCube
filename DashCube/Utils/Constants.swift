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
        static let pauseActionDuration : Double = 0.75
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
        static let highScore : String = "highScore"
        static let selectedCubeAnimation : String = "selectedCubeAnimation"
        static let selectedCubeColor : String = "selectedCubeColor"
        static let gamesPlayed : String = "gamesPlayed"
        static let totalPoints : String = "totalPoints"
    }
    // MARK: - Game Timer
    struct GameTimer {
        static let timerStartingSeconds : Int = 1
        static let timerStartingMilliSeconds : Int = 0
        static let timerMinimumMilliSeconds : Int = 69
    }
    // MARK: - Namespace names
    struct GeometryEffectName {
        static let card = "card"
    }
    // MARK: - Gameplay Values
    struct Gameplay {
        static let spikeTileOdds : Double = 25
    }
    // MARK: - Animation Cubes
    struct AnimationCubes {
        static let animationCubes : [AnimationCube] = [
            .init(animation: .basic, cubeColor: .white, requiredHighscore: .zero),
            .init(animation: .yAxisSpin, cubeColor: .white, requiredHighscore: 15),
            .init(animation: .basicWithYAxisSpin, cubeColor: .white, requiredHighscore: 30)
        ]
    }
    // MARK: - Animation Cubes
    struct ColorCubes {
        static let colorCubes : [ColorCube] = [
            .init(animation: .none, cubeColor: .cube1, requiredGamesPlayed: 0),
            .init(animation: .none, cubeColor: .cube2, requiredGamesPlayed: 10),
            .init(animation: .none, cubeColor: .cube3, requiredGamesPlayed: 20),
            .init(animation: .none, cubeColor: .cube4, requiredGamesPlayed: 30),
            .init(animation: .none, cubeColor: .cube5, requiredGamesPlayed: 40),
            .init(animation: .none, cubeColor: .cube6, requiredGamesPlayed: 50),
            .init(animation: .none, cubeColor: .cube7, requiredGamesPlayed: 60),
            .init(animation: .none, cubeColor: .cube8, requiredGamesPlayed: 70),
            .init(animation: .none, cubeColor: .cube9, requiredGamesPlayed: 80)
        ]
    }
    // MARK: - Game Center
    struct GameCenter {
        static let classicLeaderboard = "classicLeaderboard"
    }
}
