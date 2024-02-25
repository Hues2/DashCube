import SwiftUI

struct MenuBottomHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    
    var body: some View {
        VStack {
            PlayerCubesView(viewModel: viewModel)
            CustomButton(title: "play_button_title".localizedString) {
                self.viewModel.startGame()
            }
            .padding(.top, 20)
        }
        .withCardStyle(outerPadding: Constants.UI.outerMenuPadding)        
    }
}
