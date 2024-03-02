import SwiftUI

struct ColorCubeSelectionView: View {
    @ObservedObject var viewModel : CubeSelectionViewModel
    private let columns : [GridItem] = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        content
    }
}

private extension ColorCubeSelectionView {
    var content : some View {
        VStack(alignment: .leading, spacing: 15) {
            title
            grid
        }
    }
    
    var title : some View {
        Text("select_cube_color".localizedString)
            .font(.title)
            .foregroundStyle(.white)
            .fontDesign(.rounded)
            .fontWeight(.bold)
    }
    
    var grid : some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.colorCubes) { colorCube in
                cubeView(colorCube)
                    .onTapGesture {
                        self.changeSelectedColor(colorCube)
                    }
            }
        }
    }
    
    func cubeView(_ colorCube : ColorCube) -> some View {
        ZStack {
            CubeView(basicCube: colorCube)
                .scaledToFit()
            
            if colorCube.requiredGamesPlayed > self.viewModel.gamesPlayed {
                LockedView(value: colorCube.requiredGamesPlayed)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(viewModel.selectedPlayerCube.cubeColor == colorCube.cubeColor ? .white : (.white.opacity(0.2)))
        }
        .contentShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
    }
}

// MARK: - Functionality
private extension ColorCubeSelectionView {
    func changeSelectedColor(_ colorCube : ColorCube) {
        if self.viewModel.gamesPlayed >= colorCube.requiredGamesPlayed {
            withAnimation {
                self.viewModel.changeSelectedCubeColor(to: colorCube.cubeColor)
            }
        }
    }
}
