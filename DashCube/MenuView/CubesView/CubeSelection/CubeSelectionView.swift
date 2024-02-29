import SwiftUI

struct CubeSelectionView: View {
    @StateObject private var viewModel : CubeSelectionViewModel    
    
    init(cubesManager : CubesManager) {
        self._viewModel = StateObject(wrappedValue: CubeSelectionViewModel(cubesManager: cubesManager))
    }
    
    var body: some View {
        VStack {
            animationCubes
            Spacer()
        }
        .frame(maxHeight: .infinity)
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
    var cubeColors : some View {
        Text("")
    }
}
