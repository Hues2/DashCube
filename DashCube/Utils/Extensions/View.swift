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
                    .opacity(phase.isIdentity ? 1 : 0.3)
                    .rotation3DEffect(.degrees(phase.isIdentity ? 0 : -90), axis: (x: 0, y: 1, z: 0))
            }
    }
}

extension View {
    func withMenuScrollViewAnimation() -> some View {
        modifier(MenuScrollViewModifiers())
    }
}
