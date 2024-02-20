import SwiftUI

struct MenuView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var isGameCenterPresented = false
    
    var body: some View {
        content
            .sheet(isPresented: $isGameCenterPresented) {
                GameCenterView(leaderboardID: Constants.GameCenter.classicLeaderboard)
            }
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
                    .onAppear {
                        self.viewModel.fetchOverallRank()
                    }
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
                    VStack(spacing: 5) {
                        // High Score
                        row("high_score".localizedString, viewModel.highscore)
                        // Overall Rank
                        row("overall_rank".localizedString, viewModel.overallRank, true)
                    }
                    playerCubesView
                    playButton
                    showGameCenterButton
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

// MARK: - Values
private extension MenuView {
    func row(_ title : String, _ value : Int?, _ isRank : Bool = false) -> some View {
        HStack(spacing: 7.5) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            HStack(spacing: 5) {
                Group {
                    if let value {
                        Text("\(value)")
                    } else {
                        Text("-")
                    }
                }
                .font(.title)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                
                if isRank, value == 1 {
                    Image(systemName: "trophy")
                        .foregroundStyle(.yellow)
                }
            }
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

// MARK: - Game Center Button
private extension MenuView {
    var showGameCenterButton : some View {
        CustomButton(title: "game_center".localizedString) {
            self.isGameCenterPresented.toggle()
        }
    }
}
