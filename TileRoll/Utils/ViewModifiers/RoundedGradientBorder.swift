import SwiftUI

struct RoundedGradientBorder: ViewModifier {
    let colors : [Color]
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(
                        LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    )
            }
    }
}

extension View {
    func withRoundedGradientBorder(colors : [Color]) -> some View {
        modifier(RoundedGradientBorder(colors: colors))
    }
}
