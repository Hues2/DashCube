import SwiftUI

struct GridTitleView: View {
    let title : String
    let subTitle : String
    let showSubTitle : Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            if showSubTitle {
                Text(subTitle)
                    .font(.headline)
                    .fontWeight(.ultraLight)
            }
        }
        .foregroundStyle(.white)
        .fontDesign(.rounded)
    }
}
