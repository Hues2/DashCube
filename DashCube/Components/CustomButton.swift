import SwiftUI

struct CustomButton: View {
    let title : String
    let action : () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .withRoundedGradientBorder(colors: [Color.customAqua, Color.customStrawberry])
                .compositingGroup()
                .shadow(radius: 4)
        }
    }
}
