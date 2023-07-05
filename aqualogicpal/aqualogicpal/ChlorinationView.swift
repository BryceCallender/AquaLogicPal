import SwiftUI

struct ChlorinationView: View {
    @StateObject var client = AquaLogicClient.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TitleView(title: "Chlorination")
            HStack {
                Spacer()
                ChlorinationGaugeView(label: "Pool", chlorinationPercentage: client.aquaLogic?.poolChlorinatorPercent)
                Spacer()
                ChlorinationGaugeView(label: "Spa", chlorinationPercentage:
                    client.aquaLogic?.spaChlorinatorPercent)
                Spacer()
            }
        }
        .padding(.bottom, 16)
    }
}

struct ChlorinationView_Previews: PreviewProvider {
    static var previews: some View {
        ChlorinationView()
    }
}
