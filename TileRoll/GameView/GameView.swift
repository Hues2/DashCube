import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 5) {
                header
                    .withCardStyle()
                    .opacity(viewModel.gameState == .playing ? 1 : 0)
                
                game(proxy)
            }
            .overlay {
                gameOverView
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
    @ViewBuilder var gameOverView : some View {
        if viewModel.gameState == .over {
            GameOverView(viewModel: viewModel)
        }
    }
}
