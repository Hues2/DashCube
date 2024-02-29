import UIKit

/*
 All cubes displayed in the menu component will implement this basic cube animation
 */
protocol BasicCube {
    var color : UIColor { get set }
    var animation : CubeAnimation { get set }
}
