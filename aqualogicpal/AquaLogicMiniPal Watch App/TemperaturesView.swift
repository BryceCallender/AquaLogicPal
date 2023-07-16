import SwiftUI

struct TemperaturesView: View {
    @StateObject var client = AquaLogicClient.shared
    
    var body: some View {
        List {
            TemperatureCardView(
                label: "Air", temperature: client.aquaLogic?.airTemp, isMetric:
                                    client.aquaLogic?.isMetric ?? false)
            TemperatureCardView(label: "Pool", temperature: client.aquaLogic?.poolTemp, isMetric:
                                    client.aquaLogic?.isMetric ?? false)
            TemperatureCardView(label: "Spa", temperature: client.aquaLogic?.spaTemp, isMetric:
                                    client.aquaLogic?.isMetric ?? false)
        }
        .listStyle(.carousel)
    }
}

struct TemperaturesView_Previews: PreviewProvider {
    static var previews: some View {
        TemperaturesView()
    }
}
