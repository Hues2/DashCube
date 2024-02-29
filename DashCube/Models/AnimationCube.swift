import UIKit

/*
 This is used for the animation cubes in the cube selection view
 */
struct AnimationCube : BasicCube {
    let id : String
    var animation : CubeAnimation
    var color : UIColor = .white
    let requiredHighscore : Int
    
    init(animation: CubeAnimation, requiredHighscore: Int) {
        self.id = animation.rawValue
        self.animation = animation
        self.requiredHighscore = requiredHighscore
    }
}
