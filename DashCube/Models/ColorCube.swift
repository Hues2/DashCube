import SwiftUI

/*
 This is used for the color cubes in the cube selection view
 */
struct ColorCube : BasicCube, Identifiable {    
    let id : String = UUID().uuidString
    var animation : CubeAnimation
    var cubeColor : CubeColor
    let requiredGamesPlayed : Int
}
