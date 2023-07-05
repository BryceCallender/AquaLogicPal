import SwiftUI

struct ChlorinationGaugeView: View {
    var label: String
    var chlorinationPercentage: Double?
    
    @State private var minValue = 0.0
    @State private var maxValue = 100.0
    let gradient = Gradient(colors: [.yellow.opacity(0.4), .yellow])
    
    var body: some View {
        VStack {
            Gauge(value: chlorinationPercentage ?? 0, in: minValue...maxValue) {
                Text(label)
            } currentValueLabel: {
                Text(chlorinationPercentage == nil ? "?" : "\(Int(chlorinationPercentage!), format: .percent)")
                    .scaleEffect(0.75)
            }
            .tint(gradient)
            .scaleEffect(2.0, anchor: .top)
        }
        .gaugeStyle(.accessoryCircular)
        .padding()
    }
}

struct ChlorinationGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ChlorinationGaugeView(label: "Spa", chlorinationPercentage: 50)
    }
}
