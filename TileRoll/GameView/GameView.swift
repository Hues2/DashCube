import SwiftUI
import SceneKit

struct GameView: View {
    var body: some View {
        VStack {          
           GameViewControllerWrapper()
                .ignoresSafeArea()
                .border(.red)
        }
    }
}
