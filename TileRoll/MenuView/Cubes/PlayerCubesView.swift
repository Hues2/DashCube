import SwiftUI
import SceneKit

struct PlayerCubesView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var animationToggle : Bool = false
    @State private var isFirst : Bool = true
    
    var body: some View {
        content
    }
}

private extension PlayerCubesView {
    var content : some View {
        VStack(alignment: .leading, spacing: 7.5) {
            title
            cubesScrollView
        }
        .onChange(of: viewModel.selectedPlayerCube) { oldValue, newValue in
            if isFirst { self.isFirst = false }
        }
    }
    
    var title : some View {
        Text("pick_a_cube".localizedString)
            .font(.title2)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
    
    var cubesScrollView : some View {
        GeometryReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Constants.PlayerCubeValues.playerCubeOptions) { playerCube in
                        cubeNodeView(proxy: proxy, playerCube: playerCube)
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
    
    func cubeNodeView(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        ZStack(alignment: .topTrailing) {
            CubeNodeViewRepresentable(playerCube: playerCube)
                .frame(width: proxy.size.width)
            if viewModel.selectedPlayerCube == playerCube {
                selectedIcon(self.isFirst)
                    .padding()
            }
        }
        .onTapGesture {
            if self.viewModel.selectedPlayerCube != playerCube {
                self.viewModel.selectedPlayerCube = playerCube
            }
        }
        .scrollTargetLayout()
        .scrollTransition(topLeading: .interactive,
                          bottomTrailing: .interactive) { view, phase in
            view
                .scaleEffect(phase.isIdentity ? 1 : 0)
                .opacity(phase.isIdentity ? 1 : 0.5)
        }
    }
    
    func selectedIcon(_ isFirst : Bool) -> some View {
        Image(systemName: Constants.SFSymbol.checkMark)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.title2)
            .keyframeAnimator(initialValue: CheckMarkAnimation(), trigger: self.animationToggle) { content, value in
                content
                    .scaleEffect(isFirst ? 1 : value.scale)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    CubicKeyframe(1.3, duration: 0.2)
                    CubicKeyframe(1, duration: 0.2)
                }
            }
            .onAppear {
                withAnimation {
                    self.animationToggle.toggle()
                }
            }
    }
}

private extension PlayerCubesView {
    struct CheckMarkAnimation {
        var scale = 1.0
    }
}
