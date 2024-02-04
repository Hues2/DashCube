import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel : MenuViewModel
    private var namespace : Namespace.ID
    
    init(gameManager : GameManager, namespace : Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager))
        self.namespace = namespace
    }
    
    var body: some View {
        content
    }
}

// MARK: - Content
private extension MenuView {
    var content : some View {
        VStack {
            appTitle
                .padding(.bottom, 50)
            VStack {
                highScore
                playButton
            }
        }
        .withCardStyle()
    }
}

// MARK: - App Title
private extension MenuView {
    var appTitle : some View {
        Text("app_title".localizedString)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
}

// MARK: - Current high score
private extension MenuView {
    var highScore : some View {
        HStack {
            Text("high_score".localizedString)
                .font(.body)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            Text("\(viewModel.highScore)")
                .font(.body)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Play game button
private extension MenuView {
    var playButton : some View {
        CustomButton(title: "play_button_title".localizedString) {
            self.viewModel.startGame()
        }
    }
}
