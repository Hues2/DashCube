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
        VStack(alignment: .leading, spacing: 10) {
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
                    ForEach(viewModel.cubes) { playerCube in
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
            .withRoundedGradientBorder(colors: [Color(viewModel.selectedPlayerCube.color)])
        }
        .frame(height: 200)
    }
    
    func cubeNodeView(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        ZStack {
            cube(proxy: proxy, playerCube: playerCube)
            if !playerCube.isUnlocked {
                unlockCubeView(playerCube)
            }
        }
    }
    
    func cube(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        ZStack(alignment: .topTrailing) {
            CubeNodeViewRepresentable(playerCube: playerCube)
                .frame(width: proxy.size.width)
            if viewModel.selectedPlayerCube == playerCube {
                selectedIcon(self.isFirst)
                    .padding()
            }
        }
        .blur(radius: playerCube.isUnlocked ? 0 : 15)
        .disabled(!playerCube.isUnlocked)
        .onTapGesture {
            handleTap(playerCube)
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
                    SpringKeyframe(1.5, duration: 0.2, spring: .snappy)
                    SpringKeyframe(1, duration: 0.2, spring: .snappy)
                }
            }
            .onAppear {
                withAnimation {
                    // Animate the icon keyframe
                    self.animationToggle.toggle()
                }
            }
    }
    
    func unlockCubeView(_ playerCube : PlayerCube) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "lock.fill")
                Text("\(playerCube.cost) \("cubelets".localizedString)")
            }
            unlockCubeButton(playerCube)
        }
    }
    
    func unlockCubeButton(_ playerCube : PlayerCube) -> some View {
        CustomButton(title: "unlock_player_cube".localizedString) {        
            viewModel.unlockPlayerCube(playerCube)
        }
    }
}

// MARK: - Select cube
private extension PlayerCubesView {
    func handleTap(_ playerCube : PlayerCube) {
        if self.viewModel.selectedPlayerCube != playerCube {
            // Animate the border color
            withAnimation {
                self.viewModel.selectedPlayerCube = playerCube
            }
        }
    }
}

private extension PlayerCubesView {
    struct CheckMarkAnimation {
        var scale : CGFloat = 1.0
        var tint : Color = .white
    }
}
