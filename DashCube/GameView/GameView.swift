import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    @Binding private var mainGameState : GameState
    private let namespace : Namespace.ID
    
    init(gameManager : GameManager, cubesManager: CubesManager,
         gameCenterManager : GameCenterManager,
         namespace : Namespace.ID, 
         mainGameState : Binding<GameState>) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager,
                                                                  cubesManager: cubesManager,
                                                                  gameCenterManager : gameCenterManager))
        self._mainGameState = mainGameState
        self.namespace = namespace
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                if mainGameState == .playing {
                    header(proxy)
                }
                
                game(proxy)
//                    .overlay { gameInstructionsOverlay(proxy) }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Header UI
private extension GameView {
    func header(_ proxy : GeometryProxy) -> some View {
        HStack {
            headerSection(title: "best_title".localizedString, value: viewModel.highscore != nil ? "\(viewModel.highscore ?? 0)" : "-")            
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
    
    // Animation Values
    struct ScoreAnimationValues {
        var scale : CGFloat = 1.0
    }
}

// MARK: - Game UI
private extension GameView {
    func game(_ proxy : GeometryProxy) -> some View {
        GameViewControllerWrapper(frameSize: proxy.size, gameManager: viewModel.gameManager, cubesManager: viewModel.cubesManager)
            .ignoresSafeArea(edges: .bottom)
            .disabled(mainGameState != .playing)
    }
    
    @ViewBuilder func gameInstructionsOverlay(_ proxy : GeometryProxy) -> some View {
        if viewModel.showGameInstructions {
            VStack {
                HStack {
                    Group {
                        Spacer()
                        VStack {
                            Image(systemName: "target")
                                .font(.largeTitle)
                            Text("Move left")
                                .font(.title)
                        }
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        Spacer()
                    }
                    
                    VerticalLine()
                        .stroke(style: .init(lineWidth: 1, dash: [15]))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                    
                    Group {
                        Spacer()
                        VStack {
                            Image(systemName: "target")
                                .font(.largeTitle)
                            Text("Move right")
                                .font(.title)
                        }
                        .font(.title)
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, proxy.safeAreaInsets.bottom)
            .withCardStyle()
            .allowsHitTesting(false)
            .padding(.horizontal)
        }
    }
}
