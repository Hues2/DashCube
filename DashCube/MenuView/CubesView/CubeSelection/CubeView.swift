import SwiftUI

struct CubeView: View {
    let playerCube : PlayerCube
    
    var body: some View {
        CubeNodeViewRepresentable(playerCube: playerCube)
    }
}
