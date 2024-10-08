import SwiftUI
import SceneKit

struct PlayerCubeView: View {
    @StateObject private var viewModel : CubeSelectionViewModel
    @State private var showCubeSelectionSheet : Bool = false
    
    init(_ cubesManager : CubesManager, _ statsManager : StatsManager) {
        self._viewModel = StateObject(wrappedValue: CubeSelectionViewModel(cubesManager, statsManager))
    }
    
    var body: some View {
        content
            .sheet(isPresented: $showCubeSelectionSheet) {
                CubeSelectionView(viewModel: self.viewModel)
            }
    }
}

private extension PlayerCubeView {
    var content : some View {
        VStack(alignment: .center, spacing: 15) {
            title
                .padding(.bottom)
            
            cubeView
            
            customiseButton
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
            .frame(height: 150)
            .background(
                Color.customBackground
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            )
            .withRoundedGradientBorder(colors: [viewModel.selectedPlayerCube.cubeColor.color])
    }
    
    var customiseButton : some View {
        CustomButton(title: "customise_cube".localizedString) {
            withAnimation {
                self.showCubeSelectionSheet = true
            }
        }
    }
}
