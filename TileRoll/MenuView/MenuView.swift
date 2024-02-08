import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel : MenuViewModel

    var body: some View {
        if viewModel.gameState == .over {
            gameOverView
        } else {
            mainMenu
        }
    }
}

// MARK: - Content
private extension MenuView {
    var mainMenu : some View {
        VStack {
            appTitle
                .padding(.bottom, 50)
            VStack {
                highScore
                playButton
            }
        }
        .withCardStyle(outerPadding: Constants.UI.outerMenuPadding)
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

// MARK: - Game Over UI
private extension MenuView {
    var gameOverView : some View {
        GameOverView(viewModel: viewModel)
    }
}
