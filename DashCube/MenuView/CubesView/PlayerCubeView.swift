import SwiftUI
import SceneKit

struct PlayerCubeView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var showCubeSelectionSheet : Bool = false
    
    var body: some View {
        content
            .sheet(isPresented: $showCubeSelectionSheet) {
                CubeSelectionView(cubesManager: self.viewModel.cubesManager)
            }
    }
}

private extension PlayerCubeView {
    var content : some View {
        VStack(alignment: .center, spacing: 15) {
            title
                .padding(.bottom)
            
            cubeView
        }
    }
    
    var title : some View {
        Text("select_a_cube".localizedString)
            .font(.title)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
    
    var cubeView : some View {
        CubeView(basicCube: viewModel.selectedPlayerCube)
            .frame(maxWidth: .infinity)
            .background(
                Color.customBackground
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            )
            .withRoundedGradientBorder(colors: [viewModel.selectedPlayerCube.color])
            .onTapGesture {
                self.showCubeSelectionSheet = true
            }
    }
}
