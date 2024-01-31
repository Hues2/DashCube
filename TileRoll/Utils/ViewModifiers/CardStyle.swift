import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
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
}

extension View {
    func withCardStyle() -> some View {
        modifier(CardStyle())
    }
}
