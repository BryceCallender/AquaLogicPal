import SwiftUI
import Charts

struct PoolEventsChartView: View {
    var data: [ChartData] = [
        .init(name: "Pancakes", sales: 100),
        .init(name: "Waffles", sales: 50)
    ]
    
    var body: some View {
        VStack {
            Chart(data, id: \.name) { element in
              SectorMark(
                angle: .value("Sales", element.sales),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
              )
              .cornerRadius(5)
              .foregroundStyle(by: .value("Name", element.name))
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                      Text("Most Sold Style")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                      Text("mostSold")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
                
            }
        }
        .padding()
        .frame(height: 300)
    }
}

struct ChartData: Identifiable {
    var id = UUID()
    var name: String
    var sales: Int
}

#Preview {
    PoolEventsChartView()
}
