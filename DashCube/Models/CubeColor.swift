import SwiftUI

enum CubeColor : String {
    case white
    case cube1
    case cube2
    case cube3
    case cube4
    case cube5
    case cube6
    
    var color : Color {
        switch self {
        case .white:
            return Color.white
        case .cube1:
            return Color.cube1
        case .cube2:
            return Color.cube2
        case .cube3:
            return Color.cube3
        case .cube4:
            return Color.cube4
        case .cube5:
            return Color.cube5
        case .cube6:
            return Color.cube6
        }
    }
}
