import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(colors: [
            .init(hex: "#993BF5")!,
            .init(hex: "#196ae0")!,
            .init(hex: "#41ADF5")!,
            .init(hex: "#05D1D8")!,
            .init(hex: "#05D888")!,
        ], startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
