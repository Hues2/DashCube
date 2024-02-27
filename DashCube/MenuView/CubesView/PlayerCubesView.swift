import SwiftUI
import SceneKit

struct PlayerCubesView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var animationToggle : Bool = false
    @State private var isFirst : Bool = true
    
    var body: some View {
        content
            .onChange(of: viewModel.selectedPlayerCube) { oldValue, newValue in
                if isFirst { self.isFirst = false }
            }
    }
}

private extension PlayerCubesView {
    var content : some View {
        VStack(alignment: .center, spacing: 15) {
            title
                .padding(.bottom)
            cubesScrollView
            cubeColorsScrollView
        }
    }
    
    var title : some View {
        Text("select_a_cube".localizedString)
            .font(.title)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
    
    var cubesScrollView : some View {
        GeometryReader { proxy in
            ScrollViewReader { reader in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.cubes) { playerCube in
                            cubeNodeView(proxy: proxy, playerCube: playerCube)
                                .tag(playerCube.id)
                                .id(playerCube.id)
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
                .withRoundedGradientBorder(colors: [viewModel.selectedColor])
                .onAppear {
                    reader.scrollTo(viewModel.selectedPlayerCube.id)
                }
                .onChange(of: viewModel.selectedPlayerCube) { oldValue, newValue in
                    reader.scrollTo(newValue.id)
                }
            }
        }
        .frame(height: 200)
    }
    
    func cubeNodeView(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        ZStack {
            cube(proxy: proxy, playerCube: playerCube)
            if !playerCube.isUnlocked {
                lockedCubeView(playerCube)
            }
        }
    }
    
    func cube(proxy: GeometryProxy, playerCube : PlayerCube) -> some View {
        ZStack(alignment: .topTrailing) {
            CubeNodeViewRepresentable(playerCube: playerCube)
                .frame(width: proxy.size.width)
            if playerCube.isSelected {
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
    
    func lockedCubeView(_ playerCube : PlayerCube) -> some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "lock.fill")
                Text("\("highscore_required".localizedString) \(playerCube.requiredHighscore)")
            }
            .font(.title3)
            .fontDesign(.rounded)
        }
        .foregroundStyle(.white)
    }
}

// MARK: - Select cube
private extension PlayerCubesView {
    func handleTap(_ playerCube : PlayerCube) {
        if self.viewModel.selectedPlayerCube != playerCube {
            // Animate the border color
            withAnimation {
                self.viewModel.saveSelectedCube(playerCube)
            }
        }
    }
}

private extension PlayerCubesView {
    struct CheckMarkAnimation {
        var scale : CGFloat = 1.0
    }
}

// MARK: - Cube Colors
private extension PlayerCubesView {
    var cubeColorsScrollView : some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(viewModel.cubeColors) { cubeColor in
                    cubeColorView(cubeColor)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .contentMargins(0)
        .scrollIndicators(.hidden)
    }
    
    func cubeColorView(_ cubeColor : CubeColor) -> some View {
        ZStack(alignment: .topTrailing) {
            cubeColor.color
                .id(cubeColor.id)
                .tag(cubeColor.id)
                .frame(width: 75, height: 75)
                .clipShape(.rect(cornerRadius: Constants.UI.cornerRadius))
                .onTapGesture {
                    withAnimation {
                        self.viewModel.saveSelectedCubeColor(cubeColor)
                    }
                }
            if cubeColor.isSelected {
                selectedIcon(self.isFirst)
                    .padding(2)
            }
        }
    }
}
