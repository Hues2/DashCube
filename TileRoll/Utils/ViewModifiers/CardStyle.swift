import SwiftUI

struct CardStyle: ViewModifier {
    let innerPadding : CGFloat
    let outerPadding : CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(.top, innerPadding)
            .padding(Constants.UI.innerMenuPadding)
            .frame(maxWidth: .infinity)
            .background(
                Color.black
                    .opacity(0.5)
                    .blur(radius: 10)
                    .withRoundedGradientBorder(colors: [Constants.Colour.pastelBlue])
            )
            .padding(outerPadding)
    }
}

extension View {
    func withCardStyle(innerPadding : CGFloat = 0, outerPadding : CGFloat = 0) -> some View {
        modifier(CardStyle(innerPadding: innerPadding, outerPadding: outerPadding))
    }
}
