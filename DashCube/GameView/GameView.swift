import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    private var namespace : Namespace.ID
    private var showMenu : Bool
    
    init(gameManager : GameManager, cubesManager: CubesManager,
         gameCenterManager : GameCenterManager,
         namespace : Namespace.ID,
         showMenu : Bool) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager,
                                                                  cubesManager: cubesManager,
                                                                  gameCenterManager : gameCenterManager))
        self.namespace = namespace
        self.showMenu = showMenu
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 5) {
                if !showMenu {
                    header(proxy)
                }
                
                game(proxy)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Header UI
private extension GameView {
    func header(_ proxy : GeometryProxy) -> some View {
        HStack {
            if let highscore = viewModel.highscore {
                headerSection(title: "best_title".localizedString, value: "\(highscore)")
            } else {
                headerSection(title: "best_title".localizedString, value: "-")
            }
            Spacer()
            headerSection(title: "timer_title".localizedString, value: String(format: "%02d:%02d", viewModel.seconds, viewModel.milliseconds))
            Spacer()
            headerSection(title: "score_title".localizedString, value: "\(viewModel.score)", isAnimatible: true)
        }
        .frame(maxWidth: .infinity)
        .withCardStyle(innerPadding: proxy.safeAreaInsets.top,
                       horizontalPadding: Constants.UI.horizontalMenuPadding,
                       roundedBorderColours: [.clear])
        .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
        .ignoresSafeArea()
    }
    
    func headerSection(title : String, value : String, isAnimatible : Bool = false) -> some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(.white)
                .fontDesign(.rounded)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                .keyframeAnimator(initialValue: ScoreAnimationValues(), trigger: viewModel.isAnimating) { content, value in
                    content
                        .scaleEffect(isAnimatible ? value.scale : 1)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(1.5, duration: 0.2)
                        CubicKeyframe(1, duration: 0.2)
                    }
                }
        }
    }
}

// MARK: - Game UI
private extension GameView {
    func game(_ proxy : GeometryProxy) -> some View {
        GameViewControllerWrapper(frameSize: proxy.size, gameManager: viewModel.gameManager, cubesManager: viewModel.cubesManager)
            .ignoresSafeArea(edges: .bottom)
            .disabled(viewModel.gameState != .playing)
    }
}

private extension GameView {
    struct ScoreAnimationValues {
        var scale : CGFloat = 1.0
    }
}
