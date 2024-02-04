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
                score
                    .opacity(viewModel.gameState == .playing ? 1 : 0)
                
                Text(String(format: "%02d:%02d", viewModel.seconds, viewModel.milliseconds))
                    .font(.title)
                
                game(proxy)
            }
            .overlay {
                gameOverView
            }
        }
    }
}

// MARK: - Score UI
private extension GameView {
    var score : some View {
        HStack {
            Text("score_title".localizedString)
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.white)
            
            Text("\(viewModel.score)")
                .font(.largeTitle)
                .fontWeight(.light)
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
