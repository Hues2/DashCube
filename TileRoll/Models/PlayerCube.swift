import UIKit

struct PlayerCube : Identifiable, Hashable {
    let id : UUID = UUID()
    let color : UIColor
    let animation : CubeAnimation        
}
