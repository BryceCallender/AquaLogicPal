import SwiftUI
import Charts

struct PoolEventUsageChart: View {
    @Environment(AquaLogicPalStore.self) private var store
    
    @State private var barWidth = 7.0
    var isOverview: Bool
    
    @State private var selectedContentType: ContentType = .graph
    @State private var rawSelectedDate: Date?
    
    var body: some View {
        if isOverview {
            chart
        } else {
            VStack(alignment: .leading) {
                Picker("ContentType", selection: $selectedContentType) {
                    ForEach(ContentType.allCases) { type in
                        Text(type.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])
                
                if selectedContentType == .graph {
                    VStack(alignment: .leading) {
                        chart
                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        Section(header: Text("Records")) {
                            ForEach(store.poolEvents) { item in
                                HStack {
                                    Text(item.eventTime, style: .date)
                                    Text(item.eventTime, style: .time)
                                    Spacer()
                                    Text(String(describing: item.type).capitalized)
                                }
                            }
                        }
                    }
                    .overlay {
                        if store.poolEvents.isEmpty {
                            ContentUnavailableView {
                                Label("No Records", systemImage: "pencil.and.list.clipboard")
                            } description: {
                                Text("Pool Events will appear here as they trigger.")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Pool Events", displayMode: .inline)
        }
    }
    
    private var chart: some View {
        Chart {
            if (store.poolData.isEmpty) {
                RuleMark(y: .value("No pool events", 0))
                    .annotation {
                        Text("No pool events during this period.")
                            .font(.footnote)
                            .padding(10)
                    }
            } else {
                ForEach(store.poolData, id: \.name) { dataPoint in
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
                            .foregroundStyle(by: .value("Type", dataPoint.name.capitalized))
                            .annotation(position: .overlay) {
                                Text("\(dataPoint.total)")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                    }
                }
            }
        }
        .if (!isOverview && !store.poolData.isEmpty) { view in
            view.chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Most Used Event")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text(store.mostUsedPoolEvent?.capitalized ?? "")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .if (!isOverview) { view in
            view.chartXSelection(value: $rawSelectedDate)
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
        .task {
            //await store.getPoolEvents()
        }
    }
}

#Preview {
    PoolEventUsageChart(isOverview: true)
        .environment(AquaLogicPalStore())
}

#Preview {
    PoolEventUsageChart(isOverview: false)
        .environment(AquaLogicPalStore())
}

#Preview {
    PoolEventUsageChart(isOverview: false)
        .preferredColorScheme(.dark)
        .environment(AquaLogicPalStore())
}
