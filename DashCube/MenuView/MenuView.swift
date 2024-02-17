import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel : MenuViewModel

    var body: some View {
        content
    }
}

// MARK: - Content
private extension MenuView {
    var content : some View {
        VStack {
            if viewModel.isGameOver {
                gameOverView
            } else {
                mainMenu
            }
        }
    }
}

// MARK: - Main Menu
private extension MenuView {
    var mainMenu : some View {
        VStack {
            appTitle
                .padding(.top, 25)
                .padding(.bottom, 50)
            VStack {
                VStack {
                    highScore
                    playerCubesView
                    playButton
                }
            }
            .withCardStyle(outerPadding: Constants.UI.outerMenuPadding)
        }
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

// MARK: - Menu header
private extension MenuView {
    var highScore : some View {
        HStack {
            Text("high_score".localizedString)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            Text("\(viewModel.highScore)")
                .font(.title2)
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
        .padding(.top, 20)
    }
}

// MARK: - Player Cubes
private extension MenuView {
    @ViewBuilder var playerCubesView : some View {
        if viewModel.gameState == .menu {
            PlayerCubesView(viewModel: viewModel)
                .padding(.top, 20)
        }
    }
}

// MARK: - Game Over UI
private extension MenuView {
    var gameOverView : some View {
        GameOverView(viewModel: viewModel)
    }
}
