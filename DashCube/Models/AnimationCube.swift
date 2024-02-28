import Foundation

struct AnimationCube {
    let id : String
    let animation : CubeAnimation
    let requiredHighscore : Int
    
    init(animation: CubeAnimation, requiredHighscore: Int) {
        self.id = animation.rawValue
        self.animation = animation
        self.requiredHighscore = requiredHighscore
    }
}
