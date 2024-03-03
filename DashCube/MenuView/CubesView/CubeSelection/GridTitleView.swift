import SwiftUI

struct GridTitleView: View {
    let title : String
    let subTitle : String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(subTitle)
                .font(.headline)
                .fontWeight(.ultraLight)
        }
        .foregroundStyle(.white)
        .fontDesign(.rounded)
    }
}
