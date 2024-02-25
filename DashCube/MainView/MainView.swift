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
                .blur(radius: viewModel.showMenu ? 7.5 : 0)
            
            if viewModel.showMenu {
                menuView
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
                 namespace: namespace,
                 showMenu: viewModel.showMenu)
    }
}

// MARK: - Menu View
private extension MainView {
    var menuView : some View {
        MenuView(viewModel: menuViewModel, namespace: namespace)
            .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
    }
}
