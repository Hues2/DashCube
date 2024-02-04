import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel : MenuViewModel
    
    var body: some View {
        content
    }
}

private extension GameOverView {
    var content : some View {
        VStack(spacing: 50) {
            gameOverTitle
            
            VStack(spacing: 15) {
                score
                playAgainButton
                returnToMenuButton
            }
        }
        .withCardStyle()
    }
    
    var gameOverTitle : some View {
        Text("game_over".localizedString)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
    }
    
    var score : some View {
        HStack {
            Text("score_title")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text("\(viewModel.score)")
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(.white)
        }
    }
    
    var playAgainButton : some View {
        CustomButton(title: "play_again".localizedString) {
            viewModel.startGame()
        }
    }
    
    var returnToMenuButton : some View {
        CustomButton(title: "return_to_menu".localizedString) {
            viewModel.returnToMenu()
        }
    }
}
