import SwiftUI

struct CubeColor : Identifiable {
    let id : String
    let color : Color
    var isSelected : Bool
    
    init(color: Color, isSelected : Bool) {
        self.id = color.description
        self.color = color
        self.isSelected = isSelected
    }
}
