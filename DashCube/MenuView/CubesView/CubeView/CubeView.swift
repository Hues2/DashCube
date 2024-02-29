import SwiftUI

struct CubeView: View {
    let basicCube : BasicCube
    
    var body: some View {
        CubeNodeViewRepresentable(basicCube: basicCube)
    }
}
