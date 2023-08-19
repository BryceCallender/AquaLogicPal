import SwiftUI

struct TitleView: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.title)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView("Title")
    }
}
