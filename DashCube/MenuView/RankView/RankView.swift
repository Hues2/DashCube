import SwiftUI

struct RankView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var isGameCenterPresented = false
    
    var body: some View {
        rankViewContent
            .onAppear { self.viewModel.fetchOverallRank() }
            .sheet(isPresented: $isGameCenterPresented) {
                GameCenterView(leaderboardID: Constants.GameCenter.classicLeaderboard)
            }
    }
}

// MARK: - Values
private extension RankView {
    var rankViewContent : some View {
        VStack(spacing: 5) {
            // High Score
            row("high_score".localizedString, viewModel.highscore)
            // Overall Rank
            row("overall_rank".localizedString, viewModel.overallRank, true)
            // Leaderboard button
            showLeaderboardButton
                .padding(.top, 5)
        }        
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
                .fontWeight(.ultraLight)
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
private extension RankView {
    var showLeaderboardButton : some View {
        CustomButton(title: "view_leaderboard".localizedString) {
            self.isGameCenterPresented.toggle()
        }
    }
}
