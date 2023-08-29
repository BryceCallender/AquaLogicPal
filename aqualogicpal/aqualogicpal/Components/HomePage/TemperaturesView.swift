import SwiftUI

struct TemperaturesView: View {
    @StateObject var client = AquaLogicClient.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Temperatures")
                .font(.title)
                .fontWeight(.semibold)
            
            HStack {
                TemperatureCardView(label: "Air", temperature: client.aquaLogic?.airTemp, isMetric: client.aquaLogic?.isMetric ?? false)
                TemperatureCardView(label: "Pool", temperature: client.aquaLogic?.poolTemp, isMetric: client.aquaLogic?.isMetric ?? false)
                TemperatureCardView(label: "Spa", temperature: client.aquaLogic?.spaTemp, isMetric: client.aquaLogic?.isMetric ?? false)
            }
            .padding(.top, 16)
        }
        .padding()
    }
}

#Preview {
    TemperaturesView()
}
