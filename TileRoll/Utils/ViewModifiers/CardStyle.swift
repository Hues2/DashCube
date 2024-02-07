import SwiftUI

struct CardStyle: ViewModifier {
    let innerPadding : CGFloat
    let outerPadding : CGFloat
    let horizontalPadding : CGFloat
    let roundedBorderColour : Color
    
    func body(content: Content) -> some View {
        content
            .padding(.top, innerPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(Constants.UI.innerMenuPadding)
            .frame(maxWidth: .infinity)
            .background(
                Color.black
                    .opacity(0.5)
                    .blur(radius: 10)
                    .withRoundedGradientBorder(colors: [roundedBorderColour])
            )
            .padding(outerPadding)
    }
}

extension View {
    func withCardStyle(innerPadding : CGFloat = 0,
                       outerPadding : CGFloat = 0,
                       horizontalPadding : CGFloat = 0,
                       roundedBorderColour : Color = Constants.Colour.pastelBlue) -> some View {
        modifier(CardStyle(innerPadding: innerPadding,
                           outerPadding: outerPadding,
                           horizontalPadding: horizontalPadding,
                           roundedBorderColour: roundedBorderColour))
    }
}
