import SwiftUI

struct MainView: View {
    @StateObject private var viewModel : MainViewModel
    @StateObject private var menuViewModel : MenuViewModel
    @Namespace private var namespace
    
    init(gameManager : GameManager,
         cubesManager: CubesManager,
         gameCenterManager : GameCenterManager) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(gameManager: gameManager))
        self._menuViewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager,
                                                                      cubesManager: cubesManager,
                                                                      gameCenterManager : gameCenterManager))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            gameView
                .blur(radius: (viewModel.gameState == .playing) ? 0 : 7.5)
            
            if viewModel.gameState == .menu {
                menuView
            } else if viewModel.gameState == .over(timerEnded: false) ||
                        viewModel.gameState == .over(timerEnded: true) {
                gameOverView
            }
        }
        .background(Color.customBackground)
    }
}

// MARK: - Game View
private extension MainView {
    var gameView : some View {
        GameView(gameManager: viewModel.gameManager,
                 cubesManager: menuViewModel.cubesManager,
                 gameCenterManager: menuViewModel.gameCenterManager,
                 namespace: namespace)
    }
}

// MARK: - Menu View
private extension MainView {
    var menuView : some View {
        MenuView(viewModel: menuViewModel, namespace: namespace)            
    }
}

// MARK: - Game Over UI
private extension MainView {
    var gameOverView : some View {
        GameOverView(viewModel: menuViewModel)
            .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
    }
}
