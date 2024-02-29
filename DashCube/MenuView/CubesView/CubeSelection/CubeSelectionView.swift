import SwiftUI

struct CubeSelectionView: View {
    @StateObject private var viewModel : CubeSelectionViewModel    
    
    init(cubesManager : CubesManager) {
        self._viewModel = StateObject(wrappedValue: CubeSelectionViewModel(cubesManager: cubesManager))
    }
    
    var body: some View {
        VStack {
            Text("Cube Selection View")
        }
    }
}

// MARK: - Cube Animations
private extension CubeSelectionView {
    var cubeAnimations : some View {
        AnimationCubeSelectionView(viewModel: self.viewModel)
    }
}

// MARK: - Cube Colors
private extension CubeSelectionView {
    var cubeColors : some View {
        Text("")
    }
}
