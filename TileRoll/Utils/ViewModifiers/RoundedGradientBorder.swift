import SwiftUI

struct RoundedGradientBorder: ViewModifier {
    let colors : [Color]
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
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
