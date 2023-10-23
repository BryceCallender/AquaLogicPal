import SwiftUI

struct TemperaturesView: View {
    @StateObject var client = AquaLogicClient.shared
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                TemperatureCardView(label: "Air", temperature: client.aquaLogic?.airTemp, isMetric: client.aquaLogic?.isMetric ?? false)
                TemperatureCardView(label: "Pool", temperature: client.aquaLogic?.poolTemp, isMetric: client.aquaLogic?.isMetric ?? false)
                TemperatureCardView(label: "Spa", temperature: client.aquaLogic?.spaTemp, isMetric: client.aquaLogic?.isMetric ?? false)
            }
        }
    }
}

#Preview {
    TemperaturesView()
}
