import SwiftUI

struct AnimationCubeSelectionView: View {
    @ObservedObject var viewModel : CubeSelectionViewModel
    private let columns : [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        content
    }
}

private extension AnimationCubeSelectionView {
    var content : some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.animationCubes) { animationCube in
                CubeView(basicCube: animationCube)
            }
        }
    }
}
