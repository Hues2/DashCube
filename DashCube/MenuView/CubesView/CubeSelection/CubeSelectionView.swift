import SwiftUI

struct CubeSelectionView: View {
    @ObservedObject var viewModel : MenuViewModel
    private let columns : [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            Text("Cube Selection View")
        }
    }
}

// MARK: - Cube Animations
private extension CubeSelectionView {
    var cubeAnimations : some View {
        VStack {
            
        }
    }
}

// MARK: - Cube Colors
private extension CubeSelectionView {
    var cubeColors : some View {
        Text("")
    }
}
