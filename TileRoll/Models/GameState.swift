import Foundation

enum GameState : Equatable {
    case menu
    case playing
    case over(timerEnded : Bool)            
}
