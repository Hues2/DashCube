import SwiftUI

struct MenuView: View {
    @StateObject private var viewModel : MenuViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: MenuViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        VStack {
            tapToStart
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.startGame()
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
