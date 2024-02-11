import SwiftUI

struct CardStyle: ViewModifier {
    let innerPadding : CGFloat
    let outerPadding : CGFloat
    let horizontalPadding : CGFloat
    let roundedBorderColours : [Color]
    
    func body(content: Content) -> some View {
        content
            .padding(.top, innerPadding)
            .padding(.horizontal, horizontalPadding)
            .padding(Constants.UI.innerMenuPadding)
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .opacity(0.1)
                    .blur(radius: 15)
                    .withRoundedGradientBorder(colors: roundedBorderColours.reversed())
            )
            .padding(outerPadding)
    }
}

extension View {
    func withCardStyle(innerPadding : CGFloat = 0,
                       outerPadding : CGFloat = 0,
                       horizontalPadding : CGFloat = 0,
                       roundedBorderColours : [Color] = [Color.customAqua, Color.customStrawberry]) -> some View {
        modifier(CardStyle(innerPadding: innerPadding,
                           outerPadding: outerPadding,
                           horizontalPadding: horizontalPadding,
                           roundedBorderColours: roundedBorderColours))
    }
}
