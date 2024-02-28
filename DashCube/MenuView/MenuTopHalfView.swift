import SwiftUI

struct MenuTopHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var scrollPositionId : ScrollPositionId?
    
    var body: some View {
        VStack {
            appTitle
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    cubesView
                        .id(ScrollPositionId.cubes)
                    
                    rankView
                        .id(ScrollPositionId.progress)
                    
                    // TODO: Add the stats view here
                    rankView
                        .id(ScrollPositionId.stats)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(.center)
            .scrollClipDisabled()
            .scrollPosition(id: $scrollPositionId, anchor: .center)
            .onChange(of: scrollPositionId) { oldValue, newValue in
                print("NEW VALUE: \(scrollPositionId?.rawValue)")
            }
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
            .withMenuScrollViewAnimation()
    }
}

// MARK: - Rank View
private extension MenuTopHalfView {
    var rankView : some View {
        UserProgressView(viewModel: self.viewModel)
            .frame(maxHeight: .infinity)
            .withMenuScrollViewAnimation()
    }
}

// MARK: - Scroll position id
private extension MenuTopHalfView {
    enum ScrollPositionId : String {
        case cubes, progress, stats
    }
}
