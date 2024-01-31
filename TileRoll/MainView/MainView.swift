import SwiftUI

struct MainView: View {
    @StateObject private var viewModel : MainViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MainViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            GameView(gameManager: viewModel.gameManager)
            
            if viewModel.gameState == .menu {
                MenuView(gameManager: viewModel.gameManager)
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
