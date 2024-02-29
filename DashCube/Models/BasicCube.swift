import SwiftUI

/*
 All cubes displayed in the menu component will implement this basic cube animation
 */
protocol BasicCube {
    var color : Color { get set }
    var animation : CubeAnimation { get set }
}
