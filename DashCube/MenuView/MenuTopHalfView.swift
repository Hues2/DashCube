import SwiftUI

struct MenuTopHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var height : CGFloat = .zero
    
    var body: some View {
        VStack {
            appTitle
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    cubesView
                        .padding()
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                    
                    rankView
                        .padding()
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
                }
                .frame(maxHeight: .infinity)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
        }
        .padding(.top)
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

// MARK: - Cubes View
private extension MenuTopHalfView {
    var cubesView : some View {
        PlayerCubesView(viewModel: self.viewModel)
            .withCardStyle(outerPadding: 0)
    }
}

// MARK: - Rank View
private extension MenuTopHalfView {
    var rankView : some View {
        ProgressView(viewModel: self.viewModel)
            .frame(maxHeight: .infinity)
            .withCardStyle(outerPadding: 0)
    }
}
