import SwiftUI
import SceneKit

struct GameView: View {
    @StateObject private var viewModel : GameViewModel
    
    init(gameManager : GameManager) {
        self._viewModel = StateObject(wrappedValue: GameViewModel(gameManager: gameManager))
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                GameViewControllerWrapper(frameSize: proxy.size)
                    .clipShape(RoundedRectangle(cornerRadius: 12))                
            }
        }
    }
}
