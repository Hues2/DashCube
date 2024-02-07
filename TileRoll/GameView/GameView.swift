import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    private var namespace : Namespace.ID
    private var showMenu : Bool
    
    init(gameManager : GameManager, namespace : Namespace.ID, showMenu : Bool) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager))
        self.namespace = namespace
        self.showMenu = showMenu
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 5) {
                if !showMenu {
                    header(proxy)
                }
                
                game(proxy)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

// MARK: - Header UI
private extension GameView {
    func header(_ proxy : GeometryProxy) -> some View {
        HStack {
            headerSection(title: "best_title".localizedString, value: "\(viewModel.highScore)")
            Spacer()
            headerSection(title: "timer_title".localizedString, value: String(format: "%02d:%02d", viewModel.seconds, viewModel.milliseconds))
            Spacer()
            headerSection(title: "score_title".localizedString, value: "\(viewModel.score)")
        }
        .frame(maxWidth: .infinity)
        .withCardStyle(innerPadding: proxy.safeAreaInsets.top,
                       horizontalPadding: Constants.UI.horizontalMenuPadding,
                       roundedBorderColour: .clear)
        .matchedGeometryEffect(id: Constants.GeometryEffectName.card, in: namespace)
        .ignoresSafeArea()
    }
    
    func headerSection(title : String, value : String) -> some View {
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
