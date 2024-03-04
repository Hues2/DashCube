import SwiftUI

struct AnimationCubeSelectionView: View {
    @ObservedObject var viewModel : CubeSelectionViewModel
    private let columns : [GridItem] = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        content
    }
}

private extension AnimationCubeSelectionView {
    var content : some View {
        VStack(alignment: .leading, spacing: 15) {            
            GridTitleView(title: "select_cube_animation".localizedString,
                          subTitle: "unlock_with_highscore".localizedString,
                          showSubTitle: viewModel.showAnimationCubeSubTitle())
            grid
        }
    }
    
    var grid : some View {
        LazyVGrid(columns: columns) { 
            ForEach(viewModel.animationCubes) { animationCube in
                cubeView(animationCube)
                    .onTapGesture {
                        self.changeSelectedAnimation(animationCube)
                    }
            }
        }
    }
    
    func cubeView(_ animationCube : AnimationCube) -> some View {
        ZStack {
            CubeView(basicCube: animationCube)
                .scaledToFit()
            
            if animationCube.requiredHighscore > self.viewModel.highScore {
                LockedView(value: animationCube.requiredHighscore)
            }
        }
        .background(
            Color.customBackground
                .clipShape(.rect(cornerRadius: Constants.UI.cornerRadius))
        )
        .overlay {
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(viewModel.selectedPlayerCube.animation.rawValue == animationCube.animation.rawValue ? .white : (.white.opacity(0.2)))
        }
        .contentShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
    }
}

// MARK: - Functionality
private extension AnimationCubeSelectionView {
    func changeSelectedAnimation(_ animationCube : AnimationCube) {
        if self.viewModel.highScore >= animationCube.requiredHighscore {
            withAnimation {
                self.viewModel.changeSelectedAnimation(to: animationCube.animation)
            }
        }
    }
}
