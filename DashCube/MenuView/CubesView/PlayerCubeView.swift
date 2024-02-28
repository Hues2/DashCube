import SwiftUI
import SceneKit

struct PlayerCubeView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var showCubeSelectionSheet : Bool = false
    
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
        CubeView(viewModel: self.viewModel)
            .frame(maxWidth: .infinity)
            .background(
                Color.customBackground
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            )
            .withRoundedGradientBorder(colors: [viewModel.selectedColor])
            .onTapGesture {
                self.showCubeSelectionSheet = true
            }
    }
}
// MARK: - Cube Colors
//private extension PlayerCubesView {
//    func cubeColorView(_ cubeColor : CubeColor) -> some View {
//        ZStack(alignment: .topTrailing) {
//            cubeColor.color
//                .id(cubeColor.id)
//                .tag(cubeColor.id)
//                .frame(width: 75, height: 75)
//                .clipShape(.rect(cornerRadius: Constants.UI.cornerRadius))
//                .onTapGesture {
//                    withAnimation {
//                        self.viewModel.saveSelectedCubeColor(cubeColor)
//                    }
//                }
//            if cubeColor.isSelected {
//                selectedIcon(self.isFirst)
//                    .padding(2)
//            }
//        }
//    }
//}
