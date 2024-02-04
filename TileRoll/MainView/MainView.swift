import SwiftUI

struct MainView: View {
    @StateObject private var viewModel : MainViewModel
    @Namespace private var namespace
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            gameView
            
            if viewModel.showMenu {
                menuView
            }
        }
        .background(backgroundGradient)
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
        MenuView(gameManager: viewModel.gameManager)
            .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
    }
}

// MARK: - Background gradient
private extension MainView {
    var backgroundGradient : some View {
        LinearGradient(gradient: Gradient(colors: [Constants.Colour.pastelPink, Constants.Colour.pastelBlue]),
                       startPoint: .top,
                       endPoint: .bottom)
        .ignoresSafeArea()
    }
}
