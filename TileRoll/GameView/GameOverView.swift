import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel : GameViewModel
    
    var body: some View {
        content
    }
}

private extension GameOverView {
    var content : some View {
        VStack(spacing: 50) {
            gameOverTitle
            
            VStack {
                score
                    .padding(.bottom, 15)
                playAgainButton
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity)
        .background(
            Color.black
                .opacity(0.5)
                .blur(radius: 10)
                .withRoundedGradientBorder(colors: [Constants.Colour.pastelBlue])
        )
        .padding()
    }
    
    var gameOverTitle : some View {
        Text("game_over".localizedString)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
    }
    
    var score : some View {
        HStack {
            Text("score_title")
                .font(.title3)
                .fontWeight(.bold)
            Text("\(viewModel.score)")
                .font(.title3)
                .fontWeight(.light)
        }
    }
    
    var playAgainButton : some View {
        CustomButton(title: "play_again".localizedString) {
            viewModel.restartGame()
        }
    }
    
    var returnToMenuButton : some View {
        Button {
            // TODO: Show menu
        } label: {
            
        }

    }
}
