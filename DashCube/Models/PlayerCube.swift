import UIKit

struct PlayerCube : Identifiable, Hashable {
    let id : String
    let color : UIColor
    let animation : CubeAnimation
    let requiredHighscore : Int    
    var isUnlocked : Bool
    var isSelected : Bool
    
    init(color: UIColor, animation: CubeAnimation, requiredHighscore: Int, isUnlocked: Bool, isSelected: Bool) {
        self.id = color.hashValue.description
        self.color = color
        self.animation = animation
        self.requiredHighscore = requiredHighscore
        self.isUnlocked = isUnlocked
        self.isSelected = isSelected
    }
}
