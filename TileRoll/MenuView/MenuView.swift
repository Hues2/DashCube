import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel : MenuViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        VStack {
            Text("START GAME")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.white)                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    viewModel.startGame()
                }
        }
    }
}
