import SwiftUI
import Charts

struct PoolEventUsageChart: View {
    var isOverview: Bool
    
    @State private var barWidth = 7.0
    
    @State private var data: [PoolEvents] = [
        .init(name: PoolEventType.filter.rawValue, total: 323),
        .init(name: PoolEventType.lights.rawValue, total: 90),
        .init(name: PoolEventType.heater.rawValue, total: 83),
        .init(name: PoolEventType.waterfall.rawValue, total: 40)
    ]
    
    
    var body: some View {
        if isOverview {
            chart
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle("Pool Events", displayMode: .inline)
        }
    }
    
    private var chart: some View {
        Chart(data, id: \.name) { dataPoint in
            SectorMark(
                angle: .value("Event", dataPoint.total),
                innerRadius: .ratio(0.618),
                angularInset: 2.0
            )
            .cornerRadius(10)
            .if(isOverview) { chartContent in
                chartContent.foregroundStyle(.dragoonBlue.gradient)
            }
            .if(!isOverview) { chartContent in
                chartContent
                    .foregroundStyle(by: .value("Type", dataPoint.name))
                    .annotation(position: .overlay) {
                        Text("\(dataPoint.total)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
            }
            .accessibilityLabel(dataPoint.name)
            .accessibilityValue("\(dataPoint.total) times")
            .accessibilityHidden(isOverview)
        }
        //.accessibilityChartDescriptor(self)
        .if (!isOverview) { view in
            view.chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Most Used Event")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("Filter")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
}

// MARK: - Accessibility

//extension SpaUseChart: AXChartDescriptorRepresentable {
//    func makeChartDescriptor() -> AXChartDescriptor {
//        AccessibilityHelpers.chartDescriptor(forSalesSeries: data)
//    }
//}

struct PoolEventUsageChart_Previews: PreviewProvider {
    static var previews: some View {
        PoolEventUsageChart(isOverview: true)
        PoolEventUsageChart(isOverview: false)
    }
}
