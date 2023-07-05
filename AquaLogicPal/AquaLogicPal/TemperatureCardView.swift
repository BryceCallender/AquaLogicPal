import SwiftUI
import Foundation

struct TemperatureCardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var label: String
    var temperature: Int?
    var isMetric: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: temperatureToIcon())
                    .renderingMode(.original)
//                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 50))
                
                Text(label)
                    .font(.largeTitle)
                
                Text(temperatureToLabel())
                    .font(.title2)
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 120, height: 120)
    }
    
    func temperatureToIcon() -> String {
        if temperature == nil {
            return "questionmark"
        }
        
        var celsius = Float(temperature!) // assume its celsius first
        if isMetric {
            celsius = floor((celsius - 32) * 5 / 9)
        }
    
        print(celsius)
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
        
        return "Unknown"
    }
}

struct TemperatureCardView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureCardView(label: "Air", temperature: 90, isMetric: true)
        TemperatureCardView(label: "Air", temperature: 65, isMetric: true)
            .preferredColorScheme(.dark)
    }
}
