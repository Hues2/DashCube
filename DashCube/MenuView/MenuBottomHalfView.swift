import SwiftUI

struct MenuBottomHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    
    var body: some View {
        CustomButton(title: "play_button_title".localizedString) {
            self.viewModel.startGame()
        }
        .padding()
    }
}
