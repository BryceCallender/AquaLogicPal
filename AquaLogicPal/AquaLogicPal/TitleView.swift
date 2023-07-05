import SwiftUI

struct TitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Title")
    }
}
