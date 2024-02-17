import UIKit

struct PlayerCube : Identifiable, Hashable {
    let id : String
    let color : UIColor
    let animation : CubeAnimation
    let cost : Int    
    var isUnlocked : Bool
}
