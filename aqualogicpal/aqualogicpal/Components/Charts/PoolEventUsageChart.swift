import SwiftUI
import Charts

struct PoolEventUsageChart: View {
    @Environment(AquaLogicPalStore.self) private var store
    
    @State private var barWidth = 7.0
    var isOverview: Bool
    
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
        Chart(store.poolData, id: \.name) { dataPoint in
            SectorMark(
                angle: .value("Event", dataPoint.total),
                innerRadius: .ratio(0.618),
                angularInset: 2.0
            )
            .cornerRadius(10)
            .if(isOverview) { chartContent in
                chartContent.foregroundStyle(AngularGradient(colors: [.dragoonBlue], center: .center, startAngle: .zero, endAngle: .degrees(360)))
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
        .if (!isOverview) { view in
            view.chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Most Used Event")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text(store.mostUsedPoolEvent ?? "")
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
        .task {
            await store.getPoolEvents()
        }
    }
}

struct PoolEventUsageChart_Previews: PreviewProvider {
    static var previews: some View {
        PoolEventUsageChart(isOverview: true)
            .environment(AquaLogicPalStore())
        PoolEventUsageChart(isOverview: false)
            .environment(AquaLogicPalStore())
    }
}
