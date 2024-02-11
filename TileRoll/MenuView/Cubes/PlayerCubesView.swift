import SwiftUI
import SceneKit

struct PlayerCubesView: View {
    @ObservedObject var viewModel : MenuViewModel
    
    var body: some View {
        content
    }
}

private extension PlayerCubesView {
    var content : some View {
        VStack(alignment: .leading, spacing: 7.5) {
            title
            cubes
        }
    }
    
    var title : some View {
        Text("pick_a_cube".localizedString)
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
    
    var cubes : some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Constants.PlayerCubeValues.playerCubeOptions) { playerCube in
                        cubeNode(proxy: proxy, playerCube: playerCube)
                    }
                }
            }
            .contentMargins(0)
            .scrollTargetBehavior(.paging)
            .frame(maxWidth: .infinity)
            .background(
                Color.customBackground
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            )
            .withRoundedGradientBorder(colors: [.customAqua, .customStrawberry])
        }
        .frame(height: 150)
    }
    
    func cubeNode(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        CubeNodeViewRepresentable(playerCube: playerCube)
            .frame(width: proxy.size.width)
            .scrollTargetLayout()
            .scrollTransition(topLeading: .interactive,
                              bottomTrailing: .interactive) { view, phase in
                view
                    .scaleEffect(phase.isIdentity ? 1 : 0)
                    .opacity(phase.isIdentity ? 1 : 0.5)
            }
    }
}
