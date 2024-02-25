import SwiftUI

struct MenuBottomHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    
    var body: some View {
        VStack {
            playerCubesView
            playButton
        }
        .withCardStyle(outerPadding: Constants.UI.outerMenuPadding)        
    }
}

// MARK: - Play game button
private extension MenuBottomHalfView {
    var playButton : some View {
        CustomButton(title: "play_button_title".localizedString) {
            self.viewModel.startGame()
        }
        .padding(.top, 20)
    }
}

// MARK: - Player Cubes
private extension MenuBottomHalfView {
    var playerCubesView : some View {
        PlayerCubesView(viewModel: viewModel)
            .padding(.top, 20)
        
    }
}

