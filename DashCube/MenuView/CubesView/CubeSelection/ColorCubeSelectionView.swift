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
                CubeView(basicCube: colorCube)
                    .scaledToFit()
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .stroke(viewModel.selectedPlayerCube.color.description.localizedString == colorCube.color.description.localizedString ? .white : (.white.opacity(0.2)))
                    }
                    .contentShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
                    .onTapGesture {
                        withAnimation {
                            self.viewModel.changeSelectedColor(to: colorCube.color)
                        }
                    }
            }
        }
    }
}
