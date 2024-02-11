import SwiftUI
import SceneKit

struct PlayerCubesView: View {
    var body: some View {
        content
    }
}

private extension PlayerCubesView {
    var content : some View {
        VStack(alignment: .leading, spacing: 5) {
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
                    cubeNode(proxy: proxy, uiColor: .red)
                    cubeNode(proxy: proxy, uiColor: .blue)
                    cubeNode(proxy: proxy, uiColor: .purple)
                }
            }
            .contentMargins(0)
            .scrollTargetBehavior(.paging)
            .frame(maxWidth: .infinity)
            .background(Color.customBackground.clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)))
            .withRoundedGradientBorder(colors: [.customAqua, .customStrawberry])
        }
        .frame(height: 150)
    }
    
    func cubeNode(proxy: GeometryProxy, uiColor : UIColor) -> some View {
        CubeNodeViewRepresentable(uiColor: uiColor)
            .frame(width: proxy.size.width)
            .scrollTargetLayout()
            .scrollTransition(topLeading: .interactive,
                              bottomTrailing: .interactive) { view, phase in
                view
                    .scaleEffect(phase.isIdentity ? 1 : 0)
            }
    }
}
