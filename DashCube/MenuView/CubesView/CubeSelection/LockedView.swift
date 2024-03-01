import SwiftUI

struct LockedView: View {
    let value : Int
    
    var body: some View {
        VStack {
            Image(systemName: "lock.fill")
            Text("\(value)")
        }
        .foregroundStyle(.white)
        .font(.title)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.customBackground.opacity(0.6)                
                .clipShape(.rect(cornerRadius: Constants.UI.cornerRadius))
        )
    }
}
