import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel : MenuViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager))
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
    var currentHighScore : some View {
        // TODO: Implement high score
        Text("")
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

private extension MenuView {
    var tapToStart : some View {
        Text("tap_to_start".localizedString)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
            .padding(.top, 40)
    }
}
