import UIKit

struct PlayerCube : Identifiable {
    let id: UUID
    let color : UIColor
    
    init(color: UIColor) {
        self.id = UUID()
        self.color = color
    }
}
