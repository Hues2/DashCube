import UIKit

struct PlayerCube : Identifiable, Hashable {
    let id : String
    let color : UIColor
    let animation : CubeAnimation
    let requiredHighScore : Int    
    var isUnlocked : Bool
    var isSelected : Bool
}
