import UIKit

struct PlayerCube : Identifiable, Hashable {
    let id : String
    let color : UIColor
    let animation : CubeAnimation
    let requiredHighScore : Int    
    var isUnlocked : Bool
    var isSelected : Bool
    
    init(color: UIColor, animation: CubeAnimation, requiredHighScore: Int, isUnlocked: Bool, isSelected: Bool) {
        self.id = UUID().uuidString
        self.color = color
        self.animation = animation
        self.requiredHighScore = requiredHighScore
        self.isUnlocked = isUnlocked
        self.isSelected = isSelected
    }
}
