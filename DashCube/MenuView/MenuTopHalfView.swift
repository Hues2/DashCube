import SwiftUI

struct MenuTopHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var isGameCenterPresented = false
    
    var body: some View {
        content
            .onAppear { self.viewModel.fetchOverallRank() }
            .sheet(isPresented: $isGameCenterPresented) {
                GameCenterView(leaderboardID: Constants.GameCenter.classicLeaderboard)
            }
    }
}

// MARK: - Content
private extension MenuTopHalfView {
    var content : some View {
        VStack {
            appTitle
            scoreAndRank
        }
        .padding(.top, 25)
    }
}


// MARK: - App Title
private extension MenuTopHalfView {
    var appTitle : some View {
        Text("app_title".localizedString)
            .font(.largeTitle)
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundStyle(.white)
        
    }
}

// MARK: - Values
private extension MenuTopHalfView {
    var scoreAndRank : some View {
        VStack(spacing: 5) {
            // High Score
            row("high_score".localizedString, viewModel.highscore)
            // Overall Rank
            row("overall_rank".localizedString, viewModel.overallRank, true)
            // Leaderboard button
            showLeaderboardButton
        }
        .withCardStyle(outerPadding: Constants.UI.outerMenuPadding)
    }
    
    func row(_ title : String, _ value : Int?, _ isRank : Bool = false) -> some View {
        HStack(spacing: 7.5) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            HStack(spacing: 5) {
                Group {
                    if let value {
                        Text("\(isRank ? "#" : "")\(value)")
                    } else {
                        Text("-")
                    }
                }
                .font(.title)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                
                if isRank, value == 1 {
                    Image(systemName: "trophy")
                        .foregroundStyle(.yellow)
                }
            }
        }
    }
}

// MARK: - Game Center Button
private extension MenuTopHalfView {
    var showLeaderboardButton : some View {
        Button {
            self.isGameCenterPresented.toggle()
        } label: {
            Text("view_leaderboard".localizedString)
                .font(.title3)
                .fontWeight(.light)
                .foregroundStyle(.white)
                .padding(2.5)
                .overlay(alignment: .bottom) {
                    LinearGradient(gradient: Gradient(colors: [Color.customAqua, Color.customStrawberry]), startPoint: .leading, endPoint: .trailing)
                        .frame(height: 1.5, alignment: .bottom)
                        .clipShape(.rect(cornerRadius: 8))
                }
        }
    }
}
