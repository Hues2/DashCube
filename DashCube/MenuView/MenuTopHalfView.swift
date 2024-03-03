import SwiftUI

// MARK: - Scroll position id
private extension MenuTopHalfView {
    enum ScrollPositionId : String {
        case cubes, progress, stats
    }
}

struct MenuTopHalfView: View {
    @ObservedObject var viewModel : MenuViewModel
    @State private var scrollPositionId : ScrollPositionId? = .progress
    
    // Animation
    @State private var indicatorId : ScrollPositionId = .progress
    @Namespace private var namespace
    
    
    var body: some View {
        VStack {            
            Spacer()
                .frame(maxHeight: .infinity)
            
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
                guard let newValue, (newValue != indicatorId) else { return }
                withAnimation(.spring(.bouncy)) { self.indicatorId = newValue }
            }
            
            scrollIndicatorsView
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .padding(.top)        
    }
}

// MARK: - Cubes View
private extension MenuTopHalfView {
    var cubesView : some View {
        PlayerCubeView(self.viewModel.cubesManager, self.viewModel.statsManager)
            .withMenuScrollViewAnimation()
    }
}

// MARK: - Rank View
private extension MenuTopHalfView {
    var rankView : some View {
        UserProgressView(viewModel: self.viewModel)
            .withMenuScrollViewAnimation()
    }
}

// MARK: - Scroll indicator
private extension MenuTopHalfView {
    var scrollIndicatorsView : some View {
        HStack(spacing: 25) {
            indicator(.cubes)
            indicator(.progress)
            indicator(.stats)
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.white
            .opacity(0.1))
        .clipShape(.rect(cornerRadius: 30))
    }
    
    func indicator(_ indicatorId : ScrollPositionId) -> some View {
        Rectangle()
            .frame(width: 6, height: 6)
            .clipShape(.rect(cornerRadius: 2))
            .opacity(0.5)
            .overlay {
                if self.indicatorId == indicatorId {
                    Rectangle()
                        .frame(width: 14, height: 14)
                        .clipShape(.rect(cornerRadius: 2))
                        .matchedGeometryEffect(id: "indicator", in: namespace)
                }
            }
    }
}
