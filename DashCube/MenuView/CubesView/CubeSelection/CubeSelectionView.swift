import SwiftUI

struct CubeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel : CubeSelectionViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            header
            Group {
                animationCubes
                    .padding(.top)
                colorCubes
                    .padding(.bottom)
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(Color.customBackground)
    }
}

// MARK: - Header
private extension CubeSelectionView {
    var header : some View {
        ZStack(alignment: .trailing) {
            Color.customBackground
                .cornerRadius(Constants.UI.cornerRadius, corners: [.bottomLeft, .bottomRight])
                .padding(.bottom, 1)
                .background(
                    LinearGradient(colors: [.customAqua, .customStrawberry], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(Constants.UI.cornerRadius, corners: [.bottomLeft, .bottomRight])
                )
            
            Group {
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
