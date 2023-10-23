import SwiftUI
import Foundation

struct TemperatureCardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var label: String
    var temperature: Int?
    var isMetric: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: temperatureToIcon())
                .symbolRenderingMode(.hierarchical)
                .font(.system(size: 50))

            GeometryReader { g in
                VStack(alignment: .center) {
                    Text(label)
                        .font(.system(size: 12))
                    
                    Text(temperatureToLabel())
                        .font(.system(size: 10))
                }
                .padding()
            }
        }
        .padding(20)
        .multilineTextAlignment(.center)
    }
    
    func temperatureToIcon() -> String {
        if temperature == nil {
            return "questionmark"
        }
        
        var celsius = Float(temperature!) // assume its celsius first
        if isMetric {
            celsius = floor((celsius - 32) * 5 / 9)
        }

        switch celsius {
            case _ where celsius >= 37: return "thermometer.sun.fill"
            case 25..<37: return "thermometer.high"
            case 15..<25: return "thermometer.low"
            case ..<0: return "thermometer.snowflake"
            default: return "thermometer.medium"
        }
    }
    
    func temperatureToLabel() -> String {
        if let temp = temperature {
            return "\(temp)°"
        }
        
        return ""
    }
}

#Preview {
    TemperatureCardView(label: "Air", temperature: 90, isMetric: true)
}
