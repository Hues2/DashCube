import SwiftUI

struct CubeSelectionView: View {
    @StateObject private var viewModel : CubeSelectionViewModel    
    
    init(cubesManager : CubesManager) {
        self._viewModel = StateObject(wrappedValue: CubeSelectionViewModel(cubesManager: cubesManager))
    }
    
    var body: some View {
        VStack(spacing: 25) {
            animationCubes
                .padding(.top)
            colorCubes
                .padding(.bottom)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
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
