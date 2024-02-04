import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    private var namespace : Namespace.ID
    
    init(gameManager : GameManager, namespace : Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager))
        self.namespace = namespace
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 5) {
                if viewModel.gameState == .playing {
                    header
                        .withCardStyle()
                        .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
                }
                
                game(proxy)
            }
            .overlay {
                if viewModel.gameState == .over {
                    gameOverView
                        .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
                }
            }
        }
    }
}

// MARK: - Header UI
private extension GameView {
    var header : some View {
        HStack {
            headerSection(title: "best_title".localizedString, value: "\(viewModel.highScore)")
            Spacer()
            headerSection(title: "timer_title".localizedString, value: String(format: "%02d:%02d", viewModel.seconds, viewModel.milliseconds))
            Spacer()
            headerSection(title: "score_title".localizedString, value: "\(viewModel.score)")
        }
        .frame(maxWidth: .infinity)
    }
    
    func headerSection(title : String, value : String) -> some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(.white)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Game UI
private extension GameView {
    func game(_ proxy : GeometryProxy) -> some View {
        GameViewControllerWrapper(frameSize: proxy.size, gameManager: viewModel.gameManager)
            .ignoresSafeArea(edges: .bottom)
            .disabled(viewModel.gameState != .playing)
    }
}

// MARK: - Game Over UI
private extension GameView {
    var gameOverView : some View {
        GameOverView(viewModel: viewModel)
    }
}
