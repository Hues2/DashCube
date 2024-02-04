import SwiftUI

struct MainView: View {
    @StateObject private var viewModel : MainViewModel
    @Namespace private var namespace
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GameView(gameManager: viewModel.gameManager, namespace: namespace)
            
            if viewModel.gameState == .menu {
                MenuView(gameManager: viewModel.gameManager, namespace: namespace)
                    .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
            }
        }
        .background(backgroundGradient)
    }
}

private extension MainView {
    var backgroundGradient : some View {
        LinearGradient(gradient: Gradient(colors: [Constants.Colour.pastelPink, Constants.Colour.pastelBlue]),
                       startPoint: .top,
                       endPoint: .bottom)
        .ignoresSafeArea()
    }
}
