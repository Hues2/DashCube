import SwiftUI

// MARK: - Menu scrollview animation modifiers
struct MenuScrollViewModifiers : ViewModifier {
    func body(content: Content) -> some View {
        content
            .withCardStyle(outerPadding: 0)
            .padding()
            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
            .scrollTransition(topLeading: .interactive,
                              bottomTrailing: .interactive) { view, phase in
                view
                    .opacity(phase.isIdentity ? 1 : 0.1)
                    .scaleEffect(phase.isIdentity ? 1 : 0.1)
                    .rotationEffect(.degrees(phase.isIdentity ? 0 : -90))
            }
    }
}

extension View {
    func withMenuScrollViewAnimation() -> some View {
        modifier(MenuScrollViewModifiers())
    }
}
