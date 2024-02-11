import SwiftUI

struct MainView: View {
    @StateObject private var viewModel : MainViewModel
    @StateObject private var menuViewModel : MenuViewModel
    @Namespace private var namespace
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(gameManager: gameManager))
        self._menuViewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            gameView
                .ignoresSafeArea(edges: [.bottom])
            
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
        GameView(gameManager: viewModel.gameManager, namespace: namespace, showMenu: viewModel.showMenu)
    }
}

// MARK: - Menu View
private extension MainView {
    var menuView : some View {
        MenuView(viewModel: menuViewModel)
            .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
    }
}

// MARK: - Background gradient
private extension MainView {
    var backgroundGradient : some View {
        LinearGradient(gradient: Gradient(colors: [Color.customStrawberry, Color.customAqua]),
                       startPoint: .top,
                       endPoint: .bottom)
        .ignoresSafeArea()
    }
}
