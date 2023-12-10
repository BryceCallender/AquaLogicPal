//https://github.com/jordibruin/Swift-Charts-Examples

import SwiftUI
import Charts

struct SpaUseChart: View {
    @Environment(AquaLogicPalStore.self) private var store
    
    var isOverview: Bool
    
    @State private var barWidth = 7.0
    
    @State private var rawSelectedDate: Date?
    var selectedDateValue: (date: Date, count: Int)? {
        if rawSelectedDate == nil {
            return nil
        }
                
        if let spaData = store.spaData.first(where: { $0.eventTime.month == rawSelectedDate!.month }) {
            var newComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: spaData.eventTime)
            
            newComponents.day = 15
            let newDate = Calendar.current.date(from: newComponents) ?? Date.now
            
            return (newDate, spaData.count)
        }
        
        return nil
    }
    
    var maxTemp: String {
        if store.maxSpaTemp == nil {
            return "Unknown"
        }
        
        return "\(store.maxSpaTemp!)°"
    }
    
    @State private var selectedContentType: ContentType = .graph
    
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
                    ScrollView(showsIndicators: false) {
                        VStack (alignment: .leading) {
                            header
                            chart
                            ChartDetailCard(title: "Most Used", value: store.spaData.max()?.eventTime.formatted(.dateTime.month(.wide)))
                                .padding(.top, 8)
                            ChartDetailCard(title: "Average Duration", value: Formatter.timeIntervalFormatter.string(from: store.averageSpaDuration))
                                .padding(.top, 8)
                            ChartDetailCard(title: "Highest Temp", value: maxTemp)
                                .padding(.top, 8)
                            Spacer()
                        }
                        .padding()
                    }
                } else {
                    List {
                        Section(header: Text("Records")) {
                            ForEach(store.spaEvents) { item in
                                HStack {
                                    Text(item.startTime, style: .date)
                                    Spacer()
                                    Text(item.startTime, style: .time)
                                    Image(systemName: "arrow.right")
                                    Text(item.endTime, style: .time)
                                }
                            }
                        }
                    }
                    .overlay {
                        if store.spaEvents.isEmpty {
                            ContentUnavailableView {
                                Label("No Records", systemImage: "pencil.and.list.clipboard")
                            } description: {
                                Text("Records will come as you use the spa.")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Spa Uses", displayMode: .inline)
        }
    }
    
    private var chart: some View {
        Chart {
            if (store.spaData.isEmpty) {
                RuleMark(y: .value("No spa uses", 0))
                    .annotation {
                        Text("No spa uses during this period.")
                            .font(.footnote)
                            .padding(10)
                    }
            } else {
                ForEach(store.spaData) { dataPoint in
                    BarMark(
                        x: .value("Month", dataPoint.eventTime, unit: .month),
                        y: .value("Total Count", dataPoint.count),
                        width: isOverview ? .automatic : .fixed(barWidth)
                    )
                    .foregroundStyle(.dragoonBlue.gradient)
                }
            }
            
            if let selectedDateValue {
                RuleMark(
                    x: .value("Selected", selectedDateValue.date, unit: .day)
                )
                .foregroundStyle(.gray.opacity(0.3))
                
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(
                    position: .top,
                    spacing: 0,
                    overflowResolution: .init(x: .fit, y: .disabled)) {
                    ChartPopoverView()
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: Calendar.Component.month)) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
            }
        }
        .if (!isOverview) { view in
            view.chartXSelection(value: $rawSelectedDate)
        }
        //.accessibilityChartDescriptor(self)
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
//        .task {
//            await store.getSpaData()
//        }
    }
    
    @ViewBuilder
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Average Spa Use")
            
            HStack(alignment: .bottom) {
                Text("\(store.averageSpaUses)")
                    .font(.system(.title, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("uses")
                    .offset(y: -3)
            }
            
            HStack {
                Text(Formatter.dateFormatter.string(from: Date().startOfYear()))
                Text("-")
                Text(Formatter.dateFormatter.string(from: Date().endOfYear()))
            }
        }
        .fontWeight(.semibold)
        .opacity(selectedDateValue == nil ? 1 : 0)
    }
    
    @ViewBuilder
    func ChartPopoverView() -> some View {
        VStack(alignment: .leading) {
            Text("Uses")
                .font(.title3)
            
            HStack(spacing: 2) {
                Text("\(selectedDateValue!.count)")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("uses")
                    .font(.title3)
                    .textScale(.secondary)
            }
            
            Text("\(selectedDateValue!.date.formatted(.dateTime.month().year()))")
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
        .background(.popoutBackground, in: .rect(cornerRadius: 10))
    }
}

#Preview {
    SpaUseChart(isOverview: true)
        .environment(AquaLogicPalStore())
}

#Preview {
    SpaUseChart(isOverview: false)
        .environment(AquaLogicPalStore())
}

#Preview {
    SpaUseChart(isOverview: false)
        .preferredColorScheme(.dark)
        .environment(AquaLogicPalStore())
}
