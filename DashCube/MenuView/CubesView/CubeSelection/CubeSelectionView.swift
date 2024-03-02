import SwiftUI

struct CubeSelectionView: View {
    @ObservedObject var viewModel : CubeSelectionViewModel    
    
    var body: some View {
        VStack(spacing: 25) {
            animationCubes
                .padding(.top)
            colorCubes
                .padding(.bottom)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(Color.customBackground)
    }
}

// MARK: - Animations Cubes
private extension CubeSelectionView {
    var animationCubes : some View {
        AnimationCubeSelectionView(viewModel: self.viewModel)
    }
}

// MARK: - Cube Colors
private extension CubeSelectionView {
    var colorCubes : some View {
        ColorCubeSelectionView(viewModel: self.viewModel)
    }
}
