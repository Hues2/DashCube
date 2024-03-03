import SwiftUI

struct CubeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel : CubeSelectionViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            header
            scrollView
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(Color.customBackground)
    }
}

// MARK: - Header
private extension CubeSelectionView {
    var header : some View {
        VStack {
            ZStack(alignment: .trailing) {
                Text("cube_customisation".localizedString)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                
                Image(systemName: "xmark")
                    .font(.title2)
                    .fontWeight(.light)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            dismiss()
                        }
                    }
            }
            .padding()
        }
        .foregroundStyle(.white)
        .background(
            Color.customBackground
                .cornerRadius(Constants.UI.cornerRadius, corners: [.bottomLeft, .bottomRight])
                .padding(.bottom, 2)
                .background(
                    LinearGradient(colors: [.customAqua, .customStrawberry], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(Constants.UI.cornerRadius, corners: [.bottomLeft, .bottomRight])
                )
        )
    }
}

// MARK: - ScrollView
private extension CubeSelectionView {
    var scrollView : some View {
        ScrollView {
            VStack {
                animationCubes
                    .padding(.bottom)
                    .padding(.top, 20)
                colorCubes
                    .padding(.bottom)
            }
        }
    }
}

// MARK: - Animations Cubes
private extension CubeSelectionView {
    var animationCubes : some View {
        AnimationCubeSelectionView(viewModel: self.viewModel)
    }
}

// MARK: - Cube Colors
private extension CubeSelectionView {
    var colorCubes : some View {
        ColorCubeSelectionView(viewModel: self.viewModel)
    }
}
