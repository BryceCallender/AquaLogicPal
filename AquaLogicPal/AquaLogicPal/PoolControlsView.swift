import SwiftUI

struct PoolControlsView: View {    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TemperaturesView()
                PoolStatesView()
            }
        }
    }
}

struct PoolControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PoolControlsView()
    }
}
