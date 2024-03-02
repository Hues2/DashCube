import SwiftUI

/*
 This is used for the animation cubes in the cube selection view
 */
struct AnimationCube : BasicCube, Identifiable {
    let id : String = UUID().uuidString
    var animation : CubeAnimation
    var cubeColor : CubeColor
    let requiredHighscore : Int
}
