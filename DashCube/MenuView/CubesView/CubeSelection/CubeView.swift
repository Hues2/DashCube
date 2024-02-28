import SwiftUI

struct CubeView: View {
    @ObservedObject var viewModel : MenuViewModel    
    
    var body: some View {
        content
    }
}

private extension CubeView {
    var content : some View {
        ZStack {
            cube
            if !viewModel.selectedPlayerCube.isUnlocked {
                lockedCubeView
            }
        }
    }
    
    var cube : some View {
        ZStack(alignment: .topTrailing) {
            CubeNodeViewRepresentable(playerCube: viewModel.selectedPlayerCube)

            if viewModel.selectedPlayerCube.isSelected {
                selectedIcon
                    .padding()
            }
        }
        .blur(radius: viewModel.selectedPlayerCube.isUnlocked ? 0 : 15)
        .disabled(!viewModel.selectedPlayerCube.isUnlocked)
    }
    
    var selectedIcon : some View {
        Image(systemName: Constants.SFSymbol.checkMark)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.title2)
    }
    
    var lockedCubeView : some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "lock.fill")
                Text("\("highscore_required".localizedString) \(viewModel.selectedPlayerCube.requiredHighscore)")
            }
            .font(.title3)
            .fontDesign(.rounded)
        }
        .foregroundStyle(.white)
    }
}
