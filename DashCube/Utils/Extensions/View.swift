import SwiftUI

// MARK: - Menu scrollview animation modifiers
struct MenuScrollViewModifiers : ViewModifier {
    func body(content: Content) -> some View {
        content
            .withCardStyle(outerPadding: 0)
            .padding()
            .containerRelativeFrame(.horizontal, count: 1, spacing: 10)
            .scrollTransition(topLeading: .interactive,
                              bottomTrailing: .interactive) { view, phase in
                view
                    .scaleEffect(phase.isIdentity ? 1 : 0)
                    .opacity(phase.isIdentity ? 1 : 0.5)
                    .rotationEffect(.degrees(phase.isIdentity ? 0 : -90))
            }
    }
}

extension View {
    func withMenuScrollViewAnimation() -> some View {
        modifier(MenuScrollViewModifiers())
    }
}
