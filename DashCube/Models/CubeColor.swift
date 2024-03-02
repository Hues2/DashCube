import SwiftUI

enum CubeColor : String {
    case white
    case cube1
    case cube2
    case cube3
    case cube4
    
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
        }
    }
}
